class ChangeIntsToFloatsForLogs < ActiveRecord::Migration
  def change
    change_column :logs, :sunlight, :float
    change_column :logs, :moisture, :float
    change_column :logs, :temperature, :float
  end
end
