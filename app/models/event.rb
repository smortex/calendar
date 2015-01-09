class Event < ActiveRecord::Base
  validates_presence_of :calendar_id, :title, :start, :stop
  validates :start, :date => { :before => :stop }
  validates :stop, :date => { :after => :start }
  validates :recurrence, :associated => true
  belongs_to :calendar
  belongs_to :recurrence

  has_paper_trail :on => [ :destroy ]

  before_create :ensure_fb

  FB_FREE = 0
  FB_BUSY = 1

  def days_this_week(date)
    s = (start > date.beginning_of_week(:sunday)) ? start.beginning_of_day : date.beginning_of_week(:sunday)
    e = (stop  < date.end_of_week(:sunday)) ? stop.end_of_day : date.end_of_week(:sunday)

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
    return (stop.end_of_day.to_datetime - start.beginning_of_day.to_datetime).ceil != 1
  end

  def full_day?
    return start.strftime("%H:%M") == "00:00" && stop.strftime("%H:%M") == "23:59"
  end

  def starts_this_week?(week)
    return start > week.start && start < week.stop
  end

  def stops_this_week?(week)
    return stop > week.start && stop < week.stop
  end

  def procrastinate(options = {})
    self.start = start.advance(options)
    self.stop  = stop.advance(options)
  end

  def ensure_fb
    self.fb = self.calendar.default_fb if self.fb.nil?
  end
end
