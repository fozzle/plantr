class PlantType < ActiveRecord::Base
  attr_accessible :name, :sunlight, :temperature, :water
end
