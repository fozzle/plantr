class Task < ActiveRecord::Base
  include IceCube
  serialize :schedule, Hash
  
  belongs_to :plant
  attr_accessible :description, :schedule, :weeks, :days
  attr_accessor :weeks, :days

  validates_presence_of :description#, :weeks

  def schedule=(new_schedule)
    write_attribute(:schedule, new_schedule.to_hash)
  end

  def schedule
    Schedule.from_hash(read_attribute(:schedule))
  end
end
