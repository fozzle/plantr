class Sensor < ActiveRecord::Base
  belongs_to :garden
  attr_accessible :description, :name, :garden_id

end
