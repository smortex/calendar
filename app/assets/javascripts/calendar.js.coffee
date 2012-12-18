# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

close_menus = () ->
  $(".ui-menu").hide()

$(document).ready ->
  # Calendar edition
  $("form.new_calendar, form.edit_calendar").validate()
  $('input[type=text]').not(".datetime").change ->
    $('form.new_calendar, form.edit_calendar').valid()
  $("#calendar_color").simplecolorpicker()

  # Calendar view
  $('.calendar-select').button({
    icons: {
      secondary: "ui-icon-carat-2-n-s"
    }
  }).click( ->
    close_menus()
    menu = $('#calendar-menu').find('a:contains("'+$(this).text()+'")').closest('ul').clone().menu()
    menu.appendTo($('html')).show().position({
      my: "left top",
      at: "left bottom",
      of: $(this)
    });
    $(document).one("click", ->
      menu.remove()
    )
    false
  )

  $(".new-event").button({
    text: false,
    icons: {
      primary: "ui-icon-document"
    }
  }).hide()
  $("td").mouseenter( ->
    $(this).find(".ui-button").show()
  ).mouseleave( ->
    $(this).find(".ui-button").hide()
  )

  $('#month-menu').menu().hide()
  $('#month-select').button({
    icons: {
      secondary: "ui-icon-carat-2-n-s"
    }
  }).click( ->
    close_menus()
    $('#month-menu').show().position({
      my: "left top",
      at: "left bottom",
      of: $(this)
    })
    $(document).one("click", ->
      $('#month-menu').hide()
    )
    false
  )

  $('#year-menu').menu().hide()
  $('#year-select').button({
    icons: {
      secondary: "ui-icon-carat-2-n-s"
    }
  }).click( ->
    close_menus()
    $('#year-menu').show().position({
      my: "left top",
      at: "left bottom",
      of: $(this)
    })
    $(document).one("click", ->
      $('#year-menu').hide()
    )
    false
  )

  $('#previous-month').button({
    icons: {
      primary: "ui-icon-triangle-1-w"
    }
  })
  $('#next-month').button({
    icons: {
      secondary: "ui-icon-triangle-1-e"
    }
  })

  $('#edit-calendar').button({
    text: false,
    icons: {
      primary: "ui-icon-pencil"
    }
  })

  $('#show-today').button({
    text: false,
    icons: {
      primary: "ui-icon-calendar"
    }
  })
