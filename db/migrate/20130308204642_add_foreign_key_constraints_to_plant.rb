class AddForeignKeyConstraintsToPlant < ActiveRecord::Migration
  def change
  	add_foreign_key(:plants, :sensor_id, :sensors, :sens_id)
  	add_foreign_key(:plants, :gardens)

  	add_index :plants, :sensor_id, :unique => true
  end
end
