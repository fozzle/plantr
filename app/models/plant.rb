class Plant < ActiveRecord::Base
	belongs_to :garden
	belongs_to :plant_type
  attr_accessible :name, :sunlight, :temperature, :water, :plant_date
end
