class CreateFilings < ActiveRecord::Migration[7.0]
  def change
    create_table :filings do |t|
      t.timestamps
      t.references :filer, null: false, foreign_key: true
      t.boolean :amended_indicator
      t.datetime :filed_at
      t.string :tax_period_end_at
    end
  end
end
