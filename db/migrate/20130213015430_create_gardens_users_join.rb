class CreateGardensUsersJoin < ActiveRecord::Migration
  def up
  	create_table 'gardens_users', id: false do |t|
  		t.column 'garden_id', :integer
  		t.column 'user_id', :integer
  	end
  end

  def down
  	drop_table 'gardens_users'
  end
end
