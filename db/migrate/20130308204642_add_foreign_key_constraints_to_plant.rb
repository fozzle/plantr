class AddForeignKeyConstraintsToPlant < ActiveRecord::Migration
  def change
  	add_foreign_key(:plants, :sensors, {primary_key: :sens_id})
  	add_foreign_key(:plants, :gardens)

  	add_index :plants, :sensor_id, :unique => true
  end
end
