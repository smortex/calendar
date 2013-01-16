module BootstrapFlashHelper
  def bootstrap_flash
   flash_messages = []
   flash.each do |type, message|
     # Skip Devise :timeout and :timedout flags
     next if type == :timeout
     next if type == :timedout
     type = :success if type == :notice
     type = :error   if type == :alert

     icon = "icon-info-sign"
     icon = "icon-exclamation-sign" if type == :error
     icon = "icon-warning-sign" if type == :warning

     text = content_tag(:div,
              content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
              content_tag(:i, "", :class => icon) + " " +
              message, :class => "alert fade in alert-#{type}")
     flash_messages << text if message
   end
   flash_messages.join("\n").html_safe
 end
end
