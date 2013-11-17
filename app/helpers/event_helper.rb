module EventHelper
  def bootstrap_datepicker_tag(name, value = DateTime.now)
    value ||= DateTime.now
    date = value.to_s(:date)

    content_tag(:div, :class => "datepicker input-group date", :data => { "date" => date, "date-format" => "yyyy-mm-dd" }) do
      content_tag(:input, "", :class => "form-control", :type => "text", :value => date, :name => name) +
      content_tag(:span, :class => "btn input-group-addon") do
        content_tag(:i, "", :class => "fa fa-calendar")
      end
    end
  end

  def bootstrap_timepicker_tag(name, value = DateTime.now)
    value ||= DateTime.now
    time = value.to_s(:time) if value

    content_tag(:div, :class => "input-group bootstrap-timepicker-component") do
      content_tag(:input, "", :class => "timepicker form-control", :type => "text", "value" => time, :name => name) +
      content_tag(:span, :class => "btn input-group-addon timepicker") do
        content_tag(:i, "", :class => "fa fa-clock-o")
      end
    end
  end

  def procrastinate_link(name, options)
    link_to(name, procrastinate_event_path(@event, options), :method => :put)
  end
end
