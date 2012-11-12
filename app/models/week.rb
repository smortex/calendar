class Week
  attr_accessor :days, :start, :stop, :lines

  def initialize(start)
    @start = start
    @stop   = @start.end_of_week(:sunday)
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
        @lines[x].push({:colspan => event.days_this_week(@start), :event => event, :day => i})
      end
    end
    complete_lines

    @days.to_enum.with_index().each do |day, i|
      day.events.each do |event|
        x = line_index_for_day(event.start.days_to_week_start(:sunday))
        @lines[x].push({:colspan => event.days_this_week(@start), :event => event, :day => i})
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
      @lines[i].each { |h| s += h[:colspan] }

      while (s < n) do
        # This line can be completed
        @lines[i].push({:colspan => 1, :event => nil, :day => s})
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
      @lines[i].push({:colspan => 1, :event => nil, :day => s})
      s += 1
    end
    return i
  end

  def complete_lines
    @lines.each do |line|
      s = 0
      line.each { |h| s += h[:colspan] }

      while s < 7 do
        line.push({:colspan => 1, :event => nil, :day => s})
        s += 1
      end
    end
  end

  # Rotate calspans: we just want to use rowspans for display!
  def rotate_lines

    # A A   B
    # C C
    #   D
    #   E E E
    #     F  
    #     G

    rowspans = []
    @lines.each do |line|
      r = []
      line.each do |h|
        if h[:event].nil? then
          r.push(nil)
        else
          h[:colspan].times { r.push(0) }
        end
      end
      rowspans.push(r)
    end
    rowspans.push([0,0,0,0,0,0,0])

    #Rails.logger.debug(rowspans)

    (0..6).each do |d|
      l = rowspans.count - 2
      while (l >= 0) do
        if rowspans[l][d].nil? && rowspans[l+1][d].is_a?(Integer) then
          rowspans[l][d] = rowspans[l+1][d] + 1
          if rowspans[l+1][d] > 0 then
            rowspans[l+1][d] = nil
          end
        end
        l -= 1
      end
    end
    rowspans.pop

    # 0 0 3 0
    # 0 0   2
    # 4 0
    #   0 0 0
    #   2 0 2
    #     0
    #Rails.logger.debug(rowspans)
    #Rails.logger.debug("-------------------------------")

    rowspans.each_index do |l|
      new_line = []
      i = 0
      while (i < 7) do
        if rowspans[l][i].is_a?(Integer) then
          if rowspans[l][i] == 0 then
            p = 0
            n = 0
            while (n < i) do
              n += @lines[l][p][:colspan]
              p += 1;
            end
            new_line.push(@lines[l][p])
            i += @lines[l][p][:colspan]
          else
            new_line.push({:rowspan => rowspans[l][i], :event => nil, :day => i})
            i += 1
          end
        else
          i += 1
        end
      end
      @lines[l] = new_line
    end
    #Rails.logger.debug(@lines)
    #Rails.logger.debug("===============================")

  end
end
