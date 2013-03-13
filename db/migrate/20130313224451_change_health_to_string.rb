class ChangeHealthToString < ActiveRecord::Migration
  def change
    change_column :plants, :health, :string
  end
end
