# == Schema Information
#
# Table name: logs
#
#  id          :integer          not null, primary key
#  sunlight    :integer
#  moisture    :integer
#  temperature :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sensor_id   :integer
#

require 'test_helper'

class LogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
