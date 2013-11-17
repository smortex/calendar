module BootstrapFlashHelper
  def bootstrap_flash
   flash_messages = []
   flash.each do |type, message|
     # Skip Devise :timeout and :timedout flags
     next if type == :timeout
     next if type == :timedout
     type = :success if type == :notice
     type = :error   if type == :alert

     icon = "fa fa-info-circle"
     icon = "fa fa-exclamation-circle" if type == :error
     icon = "fa fa-exclamation-triangle" if type == :warning

     text = content_tag(:div,
              content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
              content_tag(:i, "", :class => icon) + " " +
              message.html_safe, :class => "alert fade in alert-#{type}")
     flash_messages << text if message
   end
   content_tag(:div, class: "row") do
   content_tag(:div, class: "col-sm-12") do
     flash_messages.join("\n").html_safe
   end
   end
 end
end
