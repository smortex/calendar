require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit, :id => events(:one)
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      start = DateTime.now
      stop  = start.advance(:hours => 3)
      post :create, {
        :event => {
          :title => "New event",
          :calendar_id => 1
        },
        :start_date => start.to_s(:date),
        :start_time => start.to_s(:time),
        :stop_date => stop.to_s(:date),
        :stop_time => stop.to_s(:time),
      }
    end
    assert_redirected_to calendar_full_path(Calendar.first, :year => DateTime.now.year, :month => DateTime.now.month, :anchor => "event-#{Event.last.id}")
  end
end
