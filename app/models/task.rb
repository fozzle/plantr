class Task < ActiveRecord::Base
  belongs_to :plant
  attr_accessible :description, :schedule
end
