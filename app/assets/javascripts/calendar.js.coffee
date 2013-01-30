# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#calendar_color").simplecolorpicker()

  if (window.location.hash != "")
    $("body").effect("transfer", { to: ".event" + window.location.hash.substring(1), className: "ui-effects-transfer" }, 1500)

  $('a.event').click( ->
    $.ajax({
      url: $(this).attr("href"),
    }).success( (data) ->
      div = $("#dialog").html(data)
      div.modal()
    )
    false
  )

  $('a.calendar_combo_item').click( ->
    $("#" + $(this).parent("li").parent("ul").attr("data-for")).val($(this).attr("data-value"))
    $("#calendar_selected_parent_name").text($(this).text())
    $('a.calendar_combo_item').parent("li").removeClass("active")
    $(this).parent("li").addClass("active")
    true
  )
