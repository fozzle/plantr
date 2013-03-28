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

  belongs_to :garden
  belongs_to :sensor
  has_many :logs
  has_many :tasks

  attr_accessor :clear_logs
  attr_accessible :name, :sensor_id, :clear_logs

  validates_presence_of :sensor_id, :name
  validate :sensor_id_exists
  validates_uniqueness_of :sensor_id

  scope :order_by_urgency, order('health DESC, updated_at DESC')

  def sunlight_status
    last_log = self.logs.last

    if last_log.nil?
      'Unknown'
    elsif last_log.sunlight > 500
      'Bright'
    elsif last_log.sunlight > 200
      'Dim'
    else
      'Dark'
    end
  end

  private

  def set_health
    last_log = self.logs.last

    if last_log.nil?
      self.health = :good
      self.save
      return
    end

    moisture = last_log.moisture
    sunlight = last_log.sunlight

    if moisture >= 800
      self.health = :overwatered
    elsif moisture >= 500 and moisture < 800
      self.health = :good
    elsif moisture < 500 and moisture >= 300
      self.health = :fair
    else
      self.health = :bad
    end
    self.save

  end

  def sensor_id_exists
    begin
      Sensor.find(self.sensor_id)
    rescue ActiveRecord::RecordNotFound
      errors.add(:sensor_id, "We couldn't find that sensor.")
      false
    end
  end

  def send_notification
    twilio_phone_number = self.garden.phone

    return if twilio_phone_number.nil?

    @twilio_client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]

    if self.health_changed?
      if (self.health_was == 'bad' or self.health_was == 'overwatered') and (self.health == 'good' or self.health == 'fair')
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
            :from => "#{twilio_phone_number}",
            :to => "#{user.phone}",
            :body => "Your #{self.name.downcase.pluralize} are doing better!"
          )
        end
      elsif self.health_was != 'bad' and self.health == 'bad'
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
            :from => "#{twilio_phone_number}",
            :to => "#{user.phone}",
            :body => "Oh no! Your #{self.name.downcase.pluralize} need water!"
          )
        end
      elsif self.health_was != 'overwatered' and self.health == 'overwatered'
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
            :from => "#{twilio_phone_number}",
            :to => "#{user.phone}",
            :body => "Oh no! Your #{self.name.downcase.pluralize} are overwatered!"
          )
        end
      end
    end
  end

  def set_default
    self.health ||= 'good'
  end
end
