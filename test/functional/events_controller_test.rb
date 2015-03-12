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

  test "should keep event time when moving" do
    e = events(:appointement)

    patch :update, id: e.id, start_date: '2015-03-12'

    e.reload
    assert_equal '2015-03-12 14:00'.to_datetime, e.start
    assert_equal '2015-03-12 16:00'.to_datetime, e.stop
  end
end
