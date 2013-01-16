require 'test_helper'

class RecurrenceTest < ActiveSupport::TestCase
  test "to_hash" do
    assert recurrences(:pi_day).to_hash[:years] = 0
    assert recurrences(:pi_day).to_hash[:months] = 3
    assert recurrences(:pi_day).to_hash[:weeks] = 0
    assert recurrences(:pi_day).to_hash[:days] = 14
  end
end
