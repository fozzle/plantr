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

  attr_accessor :clear_logs
  attr_accessible :name, :sensor_id, :clear_logs

  validates_presence_of :sensor_id, :name
  validate :sensor_id_exists
  validates_uniqueness_of :sensor_id

  def health
    last_log = self.logs.last

    return :good if last_log.nil?

    moisture = last_log.moisture
    sunlight = last_log.sunlight

    if moisture >= 0.7
      :good
    elsif moisture < 0.7 and moisture >= 0.5
      :fair
    else
      :bad
    end
  end

  private

  def sensor_id_exists
    begin
      Sensor.find(self.sensor_id)
    rescue ActiveRecord::RecordNotFound
      errors.add(:sensor_id, "We couldn't find that sensor.")
      false
    end
  end
end
