# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.datepicker').datepicker({
    autoclose: true,
    todayBtn: 'linked'
  })
  $('input.timepicker').clockface(format: 'HH:mm', trigger: 'manual')
  $('.timepicker.btn').click (e) ->
    e.stopPropagation()
    $(this).prev().clockface('toggle')
