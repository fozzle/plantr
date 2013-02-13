class ChangeSensorPlantRelationship < ActiveRecord::Migration
  def up
  	add_column :plants, :sensor_id, :integer
  	remove_column :sensors, :plant_id
  end

  def down
  	add_column :sensors, :plant_id, :integer
  	remove_column :plants, :sensor_id
  end
end
