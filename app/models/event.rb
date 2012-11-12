class Event < ActiveRecord::Base
  attr_accessible :body, :calendar_id, :stop, :start, :title

  validates_presence_of :calendar_id, :title, :start, :stop
  belongs_to :calendar

  def days_this_week(date)
    s = (start > date.beginning_of_week(:sunday)) ? start : date.beginning_of_week(:sunday)
    e = (stop  < date.end_of_week(:sunday)) ? stop : date.end_of_week(:sunday)

    return (e.to_datetime - s.to_datetime).ceil
  end

  def start_this_week(date)
    week_start = date.beginning_of_week(:sunday)
    if (week_start > start) then
      return week_start
    else
      return start
    end
  end

  def multi_day?
    return (stop.to_datetime - start.to_datetime).ceil != 1
  end

  def full_day?
    return start.strftime("%H:%M") == "00:00" && stop.strftime("%H:%M") == "23:59"
  end
end
