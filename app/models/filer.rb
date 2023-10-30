class Filer < ApplicationRecord
  has_many :filings
  has_many :grantmaker_filers, foreign_key: :grantmaker_id, class_name: 'Award'
  has_many :grantmakers, through: :grantmaker_filers
  has_many :recipient_filers, foreign_key: :recipient_id, class_name: 'Award'
  has_many :recipients, through: :recipient_filers
end