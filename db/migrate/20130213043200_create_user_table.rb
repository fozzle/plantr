class CreateUserTable < ActiveRecord::Migration
  def up
  	create_table 'users' do |t|
  		t.column 'email', :string
  		t.column 'password', :string
  	end
  end

  def down
  	drop_table 'users'
  end
end
