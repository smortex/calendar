module CalendarHelper
  def previous_month_path(date)
    date.prev_month.strftime("/%Y/%m")
  end
  def next_month_path(date)
    date.next_month.strftime("/%Y/%m")
  end
end
