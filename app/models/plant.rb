# == Schema Information
#
# Table name: plants
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  garden_id     :integer
#  plant_type_id :integer
#  plant_date    :date
#  sensor_id     :integer
#

class Plant < ActiveRecord::Base
	belongs_to :garden
	belongs_to :plant_type
	belongs_to :sensor
  attr_accessible :name, :plant_date, :plant_type_id, :garden_id, :sensor_id
end
