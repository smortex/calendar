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
    s = [start, date.beginning_of_week(:sunday)].max
    e = [stop - 1, date.end_of_week(:sunday)].min

    return (e.to_date - s.to_date).ceil + 1
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
    return ((stop - 1).to_date != start.to_date)
  end

  def full_day?
    return start.at_midnight == start && stop.at_midnight == stop
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
