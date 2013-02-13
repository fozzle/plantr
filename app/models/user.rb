class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_and_belongs_to_many :gardens
end
