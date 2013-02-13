class Sensor < ActiveRecord::Base
  belongs_to :plant
  has_many :logs
  attr_accessible :description, :name, :plant_id

end
