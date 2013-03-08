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
  self.primary_key = :sens_id

  has_one :plant
end
