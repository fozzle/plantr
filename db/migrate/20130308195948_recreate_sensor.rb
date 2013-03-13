class RecreateSensor < ActiveRecord::Migration
  def change
    drop_table :sensors

    create_table :sensors, {:id => false} do |t|
      t.string :sens_id, :null => false
    end
    add_index :sensors, :sens_id, :unique => true

    rename_column :logs, :sensor_id, :plant_id
    change_column :plants, :sensor_id, :string
  end
end
