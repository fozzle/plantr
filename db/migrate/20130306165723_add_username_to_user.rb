class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    remove_column :gardens, :garden_id
    remove_column :logs, :timestamp
  end
end
