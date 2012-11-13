module CalendarHelper
  def previous_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.prev_month.year, :month => date.prev_month.month)
  end
  def next_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.next_month.year, :month => date.next_month.month)
  end

  def options(hash, options = {})
    r = []
    sort_proc = options.delete(:sort) || lambda { |x| x.name }
    level = options.delete(:level) || 0

    hash.keys.sort_by(&sort_proc).each do |node|
      r << ["#{"--" * level} #{node.name}", node.id]
      children = options(hash[node], :sort => sort_proc, :level => level + 1)
      if children then
        r += children
      end
    end
    if r == [] then
      r = nil
    end

    return r
  end

  def colspan(n)
    if n > 1 then
      concat("colspan=\"#{n}\"".html_safe)
    end
  end
  def rowspan(n)
    if n > 1 then
      concat("rowspan=\"#{n}\"".html_safe)
    end
  end

  def other_month_class(week, day, month)
    if week.start.advance(:days => day).month != month.start.month then
      concat "other-month "
    end
  end

  def month_names
    (1..12).collect { |n| [Date::MONTHNAMES[n], n] }
  end

  def years
    ((@start.year-5) .. (@start.year+5)).collect { |n| [n, n] }
  end
end
