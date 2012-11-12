class Month
  attr_accessor :start, :stop, :weeks

  def initialize(date, events)
    @start = date.beginning_of_month
    @stop = date.end_of_month

    @weeks = []
    week = @start.beginning_of_week(:sunday)
    while week < stop do
      @weeks.push(Week.new(week))
      week = week.next_week(:sunday)
    end
  end

  def add_event(event)
    @weeks.each do |week|
      if event.start >= week.start || event.stop > week.start then
        week.add_event(event)
      end
    end
  end
end
