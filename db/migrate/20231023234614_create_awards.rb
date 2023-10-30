class CreateAwards < ActiveRecord::Migration[7.0]
  def change
    create_table :awards do |t|
      t.timestamps
      t.bigint :grantmaker_id, null: false
      t.bigint :recipient_id, null: true
      t.references :filing, null: false, foreign_key: true
      t.text :purpose
      t.decimal :cash_award, precision: 10, scale: 2
      t.text :notes
    end
    add_foreign_key :awards, :filers, column: :grantmaker_id
    add_foreign_key :awards, :filers, column: :recipient_id
  end
end
