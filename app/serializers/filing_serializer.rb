class FilingSerializer < ActiveModel::Serializer
  attributes :id, :filed_at, :tax_period_end_at

  belongs_to :filer

  attribute :award_count do
    object.awards.count
  end

  class FilerSerializer < ActiveModel::Serializer
    attributes :name, :id
  end
end
