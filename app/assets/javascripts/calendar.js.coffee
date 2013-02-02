# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

node_info_id = (node, info) ->
  new RegExp(info + "-([0-9-]+)").exec(node.prop("class"))[1]

event_id = (node) ->
  parseInt(node_info_id(node, "event"))

get_date = (node) ->
  node_info_id(node, "date")

jQuery ->
  $("#calendar_color").simplecolorpicker()

  if (window.location.hash != "")
    $("body").effect("transfer", { to: ".event-" + window.location.hash.substring(1), className: "ui-effects-transfer" }, 1500)

  $('a.event').click( ->
    if ($(this).hasClass("noclick"))
      $(this).removeClass("noclick")
      return

    $.ajax({
      url: $(this).attr("href"),
    }).success( (data) ->
      div = $("#dialog").html(data)
      div.modal()
    )
    false
  )

  $('a.event').draggable({
    revert: "invalid",
    start: (event, ui) ->
      $(this).addClass("noclick")
  })
  $("td").droppable({
    accept: "a.event"
    drop: (event, ui) ->
      ui.draggable.appendTo(this).css("top", 0).css("left", 0)
      date = get_date($(this))
      $.ajax({
        url: ui.draggable.attr("href") + "/move?to_date=" + date
      }).success (data) ->
        $("#dialog").html(data)
        $(".datepicker").datepicker({
          autoclose: true,
          todayBtn: 'linked'
        })
        $("#dialog").modal()
  })
