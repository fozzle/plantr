class AddGardenIdToSensor < ActiveRecord::Migration
  def change
    add_column :sensors, :garden_id, :integer
  end
end
