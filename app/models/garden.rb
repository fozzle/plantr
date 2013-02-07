class Garden < ActiveRecord::Base
	belongs_to :user
  attr_accessible :name

  def to_s
  	name
  end
  
end
