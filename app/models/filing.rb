class Filing < ApplicationRecord
  include IrsParsable

  validates :filer, presence: true
  validates :tax_period_end_at, presence: true

  belongs_to :filer
  has_many :awards

  scope :by_filer_for_year, -> (filer_id, tax_period_end) { 
    where(filer_id: filer_id, tax_period_end_at: tax_period_end)
  } 
end