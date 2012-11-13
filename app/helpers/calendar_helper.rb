module CalendarHelper
  def previous_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.prev_month.year, :month => date.prev_month.month)
  end
  def next_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.next_month.year, :month => date.next_month.month)
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
