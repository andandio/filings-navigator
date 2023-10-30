class CreateFilers < ActiveRecord::Migration[7.0]
  def change
    create_table :filers do |t|
      t.timestamps
      t.string :ein
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
