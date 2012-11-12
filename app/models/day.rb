class Day
  attr_accessor :full_day_events, :events, :start, :stop

  def initialize(start)
    @start = start
    @stop = @start.end_of_day
    @full_day_events = []
    @events = []
  end

  def number
    return @start.strftime("%d").to_i
  end

  def add_event(event)
    if event.multi_day? || event.full_day?
      @full_day_events.push(event)
    else
      @events.push(event)
    end
  end
end
