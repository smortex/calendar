class Week
  attr_accessor :days, :start, :stop, :lines

  def initialize(start)
    @start = start
    @stop   = @start.end_of_month
    @days = []
    
    (0..6).each do |x|
      @days.push(Day.new(start.advance(:days => x)))
    end
  end

  def add_event(event)
    @days.each do |day|
      if event.start >= day.start && event.start < day.stop || event.start < @start then
        day.add_event(event)
        return
      end
    end
  end

  def assemble_lines
    @lines = [];

    @days.to_enum.with_index().each do |day, i|
      day.full_day_events.each do |event|
        x = line_index_for_day(event.start_this_week(day.start).days_to_week_start(:sunday))
        @lines[x].push({event.days_this_week(@start) => event})
      end
    end
    complete_lines

    @days.to_enum.with_index().each do |day, i|
      day.events.each do |event|
        x = line_index_for_day(event.start.days_to_week_start(:sunday))
        @lines[x].push({event.days_this_week(@start) => event})
      end
    end
    complete_lines

    rotate_lines
  end

private
  # Return the next line ready for adding an event starting on day n of the
  # week.  If no such line is available, create a new one.
  def line_index_for_day(n)
    @lines.each_index do |i|
      s = 0
      @lines[i].each { |h| s += h.keys[0] }

      while (s < n) do
        # This line can be completed
        @lines[i].push({ 1 => nil })
        s += 1
      end
      if (s == n) then
        return i
      end
    end

    # No suitable line found, create a new one
    s = 0
    @lines.push([])
    i = @lines.count - 1
    while (s < n) do
      @lines[i].push({1 => nil})
      s += 1
    end
    return i
  end

  def complete_lines
    @lines.each do |line|
      s = 0
      line.each { |h| s += h.keys[0] }

      while s < 7 do
        line.push({1 => nil})
        s += 1
      end
    end
  end

  # Rotate calspans: we just want to use rowspans for display!
  def rotate_lines
    # TODO
  end
end
