require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit, :id => events(:one)
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => { :title => "New event", :calendar_id => 1, :start => DateTime.now.to_s(:db), :stop => DateTime.now.advance(:hours => 3).to_s(:db) }
    end
    assert_redirected_to calendar_full_path(Calendar.first, :year => DateTime.now.year, :month => DateTime.now.month)
  end
end
