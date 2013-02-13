class Log < ActiveRecord::Base
	belongs_to :sensor
  attr_accessible :moisture, :sunlight, :temperature, :sensor_id, :timestamp
end
