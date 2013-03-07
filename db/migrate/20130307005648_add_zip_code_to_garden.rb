class AddZipCodeToGarden < ActiveRecord::Migration
  def change
    add_column :gardens, :zip_code, :string
  end
end
