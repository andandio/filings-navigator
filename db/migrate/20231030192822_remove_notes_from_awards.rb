class RemoveNotesFromAwards < ActiveRecord::Migration[7.0]
  def change
    remove_column :awards, :notes, :text
  end
end
