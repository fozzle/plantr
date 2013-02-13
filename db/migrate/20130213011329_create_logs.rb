class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :timestamp
      t.integer :sunlight
      t.integer :moisture
      t.integer :temperature

      t.timestamps
    end
  end
end
