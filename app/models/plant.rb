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
  after_initialize :set_default
  after_touch :set_health
  after_save :send_notification

  HEALTH_STATES = [:good, :fair, :bad]

  belongs_to :garden
  belongs_to :sensor
  has_many :logs

  attr_accessor :clear_logs
  attr_accessible :name, :sensor_id, :clear_logs

  validates_presence_of :sensor_id, :name
  validate :sensor_id_exists
  validates_uniqueness_of :sensor_id

  scope :order_by_urgency, order('health DESC, updated_at DESC')

  def status
    health ||= 0
    HEALTH_STATES[health]
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

  def set_health
    last_log = self.logs.last

    if last_log.nil?
      self.health = :good
      return
    end

    moisture = last_log.moisture
    sunlight = last_log.sunlight

    if moisture >= 0.5
      self.health = :good
    elsif moisture < 0.5 and moisture >= 0.3
      self.health = :fair
    else
      self.health = :bad
    end
  end

  def send_notification
    if self.health_changed?
      if self.health_was == 'bad' and self.health != 'bad'
        logger.debug self.health
      elsif self.health_was != 'bad' and self.health == 'bad'
        logger.debug self.health
      end
    end
  end

  def set_default
    self.health ||= 'good'
  end
end
