class RemoveMetaDataFromPlants < ActiveRecord::Migration
  def up
  	remove_column :plants, :sunlight
  	remove_column :plants, :temperature
  	remove_column :plants, :water
  end

  def down
  	add_column :plants, :sunlight, :string
  	add_column :plants, :temperature, :string
  	add_column :plants, :water, :string
  end
end
