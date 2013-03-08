class RecreateSensor < ActiveRecord::Migration
  def change
    drop_table :sensors

    create_table :sensors, {:id => false, :primary_key => :sens_id} do |t|
      t.string :sens_id, :null => false
    end

    rename_column :logs, :sensor_id, :plant_id
    change_column :plants, :sensor_id, :string
  end
end
