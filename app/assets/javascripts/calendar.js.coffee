# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#calendar_color").simplecolorpicker()

  $('a.event').click( ->
    $.ajax({
      url: $(this).attr("href"),
    }).success( (data) ->
      div = $("#dialog").html(data)
      div.modal()
    )
    false
  )
