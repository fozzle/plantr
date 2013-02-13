class Garden < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :plants
  attr_accessible :name

  def to_s
  	name
  end
  
end
