class ChangePlantIdToString < ActiveRecord::Migration
  def up
  	remove_column :logs, :plant_id
  	add_column :logs, :plant_id, :string
  end

  def down
  	remove_column :logs, :plant_id
  	add_column :logs, :plant_id, :integer
  end
end
