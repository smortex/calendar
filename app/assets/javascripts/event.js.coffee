# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  jQuery.validator.addMethod("datetime", (value, element) ->
    return this.optional(element) || /^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}$/i.test(value);
  , "A valid date and time is required.");

  $('form.new_event, form.edit_event').validate()
  $('.datetime').datetimepicker({ dateFormat: 'yy-mm-dd', timeFormat: 'HH:mm', changeMonth: true, changeYear: true, showOtherMonths: true, selectOtherMonths: true})
