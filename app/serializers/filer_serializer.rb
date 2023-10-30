class FilerSerializer < ActiveModel::Serializer
  attributes :id, :ein, :name, :address, :city, :state, :zip

  attribute :filing_years do
    if @instance_options[:filing_years]
      object.filings.map(&:tax_period_end_at)
    end
  end 
end
