class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.string :sunlight
      t.string :water
      t.string :temperature

      t.timestamps
    end
  end
end
