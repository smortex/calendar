require 'test_helper'

class CalendarTest < ActiveSupport::TestCase
  test "should not save calendar without name" do
    c = Calendar.new(:color => '#ff0000')
    assert !c.save
  end

  test "should not save calendar without color" do
    c = Calendar.new(:name => 'Test Calendar')
    assert !c.save
  end
end
