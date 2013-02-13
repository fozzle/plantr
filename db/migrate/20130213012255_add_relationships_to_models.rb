class AddRelationshipsToModels < ActiveRecord::Migration
  def change
  	add_column :logs, :sensor_id, :integer
  	add_column :sensors, :plant_id, :integer
  	remove_column :sensors, :garden_id

  	add_column :plants, :plant_type_id, :integer
  	add_column :plants, :plant_date, :date
  end
end
