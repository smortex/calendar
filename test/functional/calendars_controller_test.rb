require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  test "should create calendar" do
    assert_difference('Calendar.count') do
      post :create, :calendar => { :name => 'New Calendar', :color => '#ff0000' }
    end
    assert_redirected_to calendars_path
  end
end
