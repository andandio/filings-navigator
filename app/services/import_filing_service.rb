class ImportFilingService < BaseService
  def initialize(filing_data)
    @header_data = filing_data["Return"]["ReturnHeader"]
    @filer = @header_data["Filer"]
    @return_data = filing_data["Return"]["ReturnData"]
    @return_type = @header_data["ReturnTypeCd"]
    @awards = award_list_path
  end

  def call
    filer = Filer.find_or_initialize_by(ein: @filer["EIN"])
    p "Importing filer info for #{@filer['EIN']}"
    tax_period_end = @header_data["TaxPeriodEndDt"]
    return_ts = @header_data["ReturnTs"]
    filed_at = DateTime.parse(return_ts)
    amended_return = @return_data["IRS#{@return_type}"].keys.include?("AmendedReturnInd")

    prev_filing = filer.persisted? ? Filing.by_filer_for_year(filer.id, tax_period_end).first : nil
    
    # save nothing, this is an invalid return
    # seems there can be multiple amended returns, 
    # so look exclusively to filed date
    return unless !prev_filing || (prev_filing && filed_at > prev_filing.filed_at)
    
    filing = prev_filing ? prev_filing : Filing.new(tax_period_end_at: tax_period_end)

    # only store the valid tax return, update previous if it exists
    filing.filed_at = filed_at
    filing.amended_indicator = amended_return
  
    Filing.transaction do
      persist_filer(filer, @filer, false)
      filing.filer_id = filer.id
      filing.save!
    end
    persist_awards(filing, filer)
  end

  private

  def persist_awards(filing, filer)
    p @awards.count
    Award.transaction do
      @awards.each do |a|
        if a.kind_of?(Array)
          # some donations have generalized/unspecified recipients
          # create awards with no specified recipient
          a = @awards
        else
          # ex. unprocessable award entry --> {"PurposeOfGrantTxt"=>"General Support"}
          next if a.keys.length == 1

          # search by ein, then search by name + zip match if no ein
          if a["RecipientEIN"]
            recipient = Filer.find_or_initialize_by(ein: a["RecipientEIN"])
          else 
            recipient = Filer.find_or_initialize_by(
              name: Filing.parse_filer_name(a, true),
              zip: Filing.parse_filer_address(a)[3],
            )
          end
        end
        # don't update existing with
        # grantmaker-provided data
        if recipient && !recipient.persisted?
          persist_filer(recipient, a, true)
        end
        
        award = Award.find_or_initialize_by(
          grantmaker_id: filer.id,
          recipient_id: recipient ? recipient.id : nil,
          filing_id: filing.id
        )
        award.cash_award = Filing.parse_cash_award_amount(a)
        award.purpose = Filing.parse_purpose(a)
        award.save!
      end
    end
  end

  def persist_filer(filer, data, is_recipient)
    filer.name = Filing.parse_filer_name(data, is_recipient)
    address = Filing.parse_filer_address(data)
    # assign a blank ein to enforce model scope validation
    filer.ein = "" if filer.ein == nil
    filer.address = address[0]
    filer.city = address[1] 
    filer.state = address[2] 
    filer.zip = address[3]
    filer.save!
  end

  def award_list_path
    path = @return_data
    keys = Filing::IRS_FORMS_MAP[@return_type.to_sym][:awardList]
    keys.each {|k| path = path[k] }
    path
  end
end