class Award < ApplicationRecord
  belongs_to :grantmaker, class_name: "Filer"
  belongs_to :recipient, class_name: "Filer", optional: true
  belongs_to :filing

  validates :grantmaker_id, presence: true
  validates :filing_id, presence: :true
end