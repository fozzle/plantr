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

  attr_accessor :clear_logs
  attr_accessible :name, :sensor_id, :clear_logs

  validates_presence_of :sensor_id, :name
  validate :sensor_id_exists
  validates_uniqueness_of :sensor_id

  scope :order_by_urgency, order('health DESC, updated_at DESC')

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

    if moisture >= 800
      self.health = :overwatered
    elsif moisture >= 500 and moisture < 800
      self.health = :good
    elsif moisture < 500 and moisture >= 300
      self.health = :fair
    else
      self.health = :bad
    end
  end

  def send_notification
    twilio_sid = "AC3d33aec0094782093e058f29c5093856"
    twilio_token = "c7151b10ee5ad0318135974ad31e8cae"
    twilio_phone_number = self.garden.phone

    return if twilio_phone_number.empty?

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    if self.health_changed?
      if self.health_was == 'bad' and (self.health == 'good' or self.health == 'fair')
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
                :from => "+1#{twilio_phone_number}",
                :to => "#{user.phone}",
                :body => "Your #{self.name.pluralize} are doing better!"
          )
        end
      elsif (self.health_was != 'good' or self.health_was == 'fair') and self.health == 'bad'
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
                :from => "+1#{twilio_phone_number}",
                :to => "#{user.phone}",
                :body => "Oh no! Your #{self.name.pluralize} need water!"
          )
        end
      elsif (self.health_was != 'good' or self.health_was == 'fair') and self.health == 'overwatered'
        self.garden.users.each do |user|
          next if user.phone.nil?

          @twilio_client.account.sms.messages.create(
                :from => "+1#{twilio_phone_number}",
                :to => "#{user.phone}",
                :body => "Oh no! Your #{self.name.pluralize} are overwatered!"
          )
        end
      end
    end
  end

  def set_default
    self.health ||= 'good'
  end
end
