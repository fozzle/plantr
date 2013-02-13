class AddGardenToPlant < ActiveRecord::Migration
  def change
  	add_column :plants, :garden_id, :integer
  end
end
