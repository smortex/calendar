module EventHelper
  def bootstrap_datepicker_tag(name, value = DateTime.now)
    value ||= DateTime.now
    date = value.to_s(:date)

    content_tag(:div, :class => "datepicker input-append date", :data => { "date" => date, "date-format" => "yyyy-mm-dd" }) do
      content_tag(:input, "", :class => "input-medium", :type => "text", :value => date, :name => name) +
      content_tag(:span, :class => "add-on") do
        content_tag(:i, "", :class => "icon-calendar")
      end
    end
  end

  def bootstrap_timepicker_tag(name, value = DateTime.now)
    value ||= DateTime.now
    time = value.to_s(:time) if value

    content_tag(:div, :class => "input-append bootstrap-timepicker-component") do
      content_tag(:input, "", :class => "timepicker input-mini", :type => "text", "value" => time, :name => name) +
      content_tag(:span, :class => "add-on") do
        content_tag(:i, "", :class => "icon-time")
      end
    end
  end

  def procrastinate_link(name, options)
    link_to(name, event_procrastinate_path(@event, options), :method => :put)
  end
end
