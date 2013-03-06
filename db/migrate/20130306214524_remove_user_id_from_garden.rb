class RemoveUserIdFromGarden < ActiveRecord::Migration
  def change
  	remove_column :gardens, :user_id
  end
end
