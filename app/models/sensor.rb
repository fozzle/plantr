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
  before_create :generate_id

  self.primary_key = :sens_id

  has_one :plant, :dependent => :destroy
  has_many :logs, :through => :plants

  private

  def generate_id
    require 'securerandom'

    begin
      id = SecureRandom.urlsafe_base64(8)
    end while Sensor.where(:sens_id => id).exists?
    
    self.id = id
  end
end
