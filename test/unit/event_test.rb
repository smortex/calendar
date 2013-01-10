require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "should procrastinate" do
    event = events(:one)
    event.procrastinate(:days => 1, :months => 1, :years => 1)
    assert_equal true, event.save
    assert_equal '2013-12-08 16:30:09'.to_datetime, event.start
    assert_equal '2013-12-09 16:30:09'.to_datetime, event.stop
  end
end
