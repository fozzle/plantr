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
  has_many :plants, :dependent => :delete_all
  attr_accessible :name, :zip_code

  validates_presence_of :name

  validates :zip_code, :format => { :with => /^\d{5}(-\d{4})?$/ ,
            :message => "should be in the form 12345 or 12345-1234" },
            :allow_blank => true

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
