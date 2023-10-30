class AwardSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :grantmaker, class_name: "Filer"
  belongs_to :recipient, class_name: "Filer", optional: true
  belongs_to :filing

  class FilerSerializer < ActiveModel::Serializer
    attributes :name
  end

  class FilingSerializer < ActiveModel::Serializer 
    attribute :tax_period_end_at
  end

  attributes :cash_award, :purpose
end
