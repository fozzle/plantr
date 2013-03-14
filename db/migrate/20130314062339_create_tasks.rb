class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.text :schedule
      t.references :plant

      t.timestamps
    end
    add_index :tasks, :plant_id
  end
end
