class Plant < ActiveRecord::Base
	belongs_to :garden
	belongs_to :plant_type
	belongs_to :sensor
  attr_accessible :name, :plant_date, :plant_type_id, :garden_id, :sensor_id
end
