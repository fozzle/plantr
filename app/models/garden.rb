# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Garden < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :plants
  attr_accessible :name

  validates_presence_of :name

  def to_s
  	name
  end

  def has_user(user)
  	self.users.all.include?(user)
  end

  def has_plant(plant)
  	self.plants.all.include?(plant)
  end
  
end
