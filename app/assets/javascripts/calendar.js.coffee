# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

navigate = () ->
  window.location = "/calendars/" + $('#calendar_id').val() + "/" + $('#date_year').val() + "/" + $('#date_month').val()

$(document).ready ->
  $('#calendar_id').change ->
    navigate()
  $('#date_year').change ->
    navigate()
  $('#date_month').change ->
    navigate()

