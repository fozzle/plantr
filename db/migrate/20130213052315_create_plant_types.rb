class CreatePlantTypes < ActiveRecord::Migration
  def change
    create_table :plant_types do |t|
      t.string :name
      t.integer :sunlight
      t.integer :water
      t.integer :temperature

      t.timestamps
    end
  end
end
