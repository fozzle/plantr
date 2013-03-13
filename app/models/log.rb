# == Schema Information
#
# Table name: logs
#
#  id          :integer          not null, primary key
#  sunlight    :integer
#  moisture    :integer
#  temperature :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sensor_id   :integer
#

class Log < ActiveRecord::Base
  belongs_to :plant, :touch => true
  attr_accessible :moisture, :sunlight, :temperature, :plant_id

  validates_presence_of :moisture, :sunlight, :temperature

end
