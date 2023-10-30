class AddIndexToFilersEin < ActiveRecord::Migration[7.0]
  def change
    add_index :filers, [:ein, :name, :zip], unique: true
  end
end
