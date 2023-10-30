module IrsParsable
  extend ActiveSupport::Concern

  # possibly more robust mapping with returnVersions: 
  # ie, "returnVersion"=>"2017v2.3"
  IRS_FORMS_MAP = {
    "990PF": { 
        "awardList": ["IRS990PF", "SupplementaryInformationGrp", "GrantOrContributionPdDurYrGrp"],
    },
    "990": { 
       "awardList": ["IRS990ScheduleI", "RecipientTable"],
    }
  }

  class_methods do
    def parse_cash_award_amount(blob, generic_recipient=false)
      return blob["CashGrantAmt"].to_d if blob.keys.include?("CashGrantAmt")
      return blob["Amt"].to_d if blob.keys.include?("Amt")
    end

    def parse_purpose(blob)
      return blob["PurposeOfGrantTxt"] if blob.keys.include?("PurposeOfGrantTxt")
      return blob["GrantOrContributionPurposeTxt"] if blob.keys.include?("GrantOrContributionPurposeTxt")
    end

    def parse_filer_name(blob, is_recipient=false)
      name_key = "#{is_recipient ? "Recipient" : ""}BusinessName"
      blob[name_key]["BusinessNameLine1Txt"]
    end

    def parse_filer_address(blob)
      address_key = blob.keys.include?("USAddress") ? "USAddress" : "RecipientUSAddress"
      [
        blob[address_key]["AddressLine1Txt"],
        blob[address_key]["CityNm"],
        blob[address_key]["StateAbbreviationCd"],
        blob[address_key]["ZIPCd"]
      ]
    end
  end
end   