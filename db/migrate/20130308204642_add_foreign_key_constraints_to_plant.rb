class AddForeignKeyConstraintsToPlant < ActiveRecord::Migration
  def change
  	add_foreign_key(:plants, :sensors)
  	add_foreign_key(:plants, :gardens)

  	add_index :plants, :sensor_id, :unique => true
  end
end
