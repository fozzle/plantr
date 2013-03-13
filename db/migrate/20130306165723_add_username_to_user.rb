class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    remove_column :logs, :timestamp
  end
end
