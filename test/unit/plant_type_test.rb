# == Schema Information
#
# Table name: plant_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  sunlight    :integer
#  water       :integer
#  temperature :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PlantTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
