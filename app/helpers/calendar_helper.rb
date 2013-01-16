module CalendarHelper
  def previous_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.prev_month.year, :month => date.prev_month.month)
  end
  def next_month_path(date)
    calendar_full_path(:calendar_id => @calendar.id, :year => date.next_month.year, :month => date.next_month.month)
  end

  def calendar_submenu(calendar)
    if calendar.children.count > 0 then
      content_tag(:ul, :class => "dropdown-menu") do
        html = "".html_safe
        calendar.children.sort { |l,r| l.name <=> r.name }.each do |c|
          html += calendar_menu(c)
        end
        html.html_safe
      end
    else
      return ""
    end
  end

  def calendar_children_menu(calendar)
    html = "".html_safe
    calendar.children.sort { |l,r| l.name <=> r.name }.each do |c|
      html += calendar_menu(c)
    end
    html
  end

  def calendar_siblings_menu(calendar)
    html = "".html_safe
    calendar.self_and_siblings.sort { |l,r| l.name <=> r.name }.each do |c|
      html += calendar_menu(c)
    end
    html
  end

  def calendar_menu(calendar)
    css_class = []
    css_class << "dropdown-submenu" if calendar.children.count > 0

    content_tag(:li, :class => css_class) do
      link_to(calendar.name, calendar_path(calendar)) + calendar_submenu(calendar)
    end
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

  def day_name(date)
    date.strftime("%A").downcase
  end

  def month_names
    (1..12).collect { |n| [Date::MONTHNAMES[n], n] }
  end

  def years
    ((@start.year-5) .. (@start.year+5)).collect { |n| [n, n] }
  end
end
