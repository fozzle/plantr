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
  belongs_to :sensor
  has_many :logs

  validate :sensor_id_exists
  validates_uniqueness_of :sensor_id

  attr_accessor :reset
  attr_accessible :name, :garden_id, :sensor_id, :reset

  private

  def sensor_id_exists
    begin
      Sensor.find(self.sensor_id)
    rescue ActiveRecord::RecordNotFound
      errors.add(:sensor_id, "Sorry, we couldn't find that sensor.")
      false
    end
  end
end
