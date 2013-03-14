class AddPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :gardens, :phone, :string
  end
end
