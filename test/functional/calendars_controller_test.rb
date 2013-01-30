require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  test "should create calendar" do
    assert_difference('Calendar.count') do
      post :create, :calendar => { :name => 'New Calendar', :color => '#ff0000' }
    end
    assert_redirected_to calendars_path
  end

  test "should show event starting in preceding month" do
    get :show, :calendar_id => 1, :month => 12, :year => 2012
    assert_select "a", {:text => "Elbeuf en Bray"}, "This event should be visible"

    get :show, :calendar_id => 1, :month => 1, :year => 2013
    assert_select "a", {:text => "Elbeuf en Bray"}, "This event should be visible"
  end

  test "should show events spanning many months" do
    get :show, :calendar_id => 1, :month => 7, :year => 2012
    assert_select "a", {:text => "Mayotte"}, "This event should be visible"
  end

  test "should show the right month at end of year" do
    Delorean.time_travel_to "2012-12-30 15:19:00"
    get :show, :calendar_id => 1
    assert_select "a", {:text => "January 1st, 2013"}, "January 1st, 2013 should be visible"
  end
end
