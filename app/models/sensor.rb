class Sensor < ActiveRecord::Base
  has_many :plants
  has_many :logs
  attr_accessible :description, :name, :plant_id

end
