# == Schema Information
#
# Table name: sensors
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Sensor < ActiveRecord::Base
  has_one :plants
  has_many :logs
  attr_accessible :description, :name, :plant_id

end
