module CalendarHelper
  def previous_month_path(date)
    date.prev_month.strftime("/%Y/%m")
  end
  def next_month_path(date)
    date.next_month.strftime("/%Y/%m")
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
end
