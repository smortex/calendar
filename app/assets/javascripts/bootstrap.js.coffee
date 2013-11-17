jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $("input.btn").each ->
    $(this).css("height", (parseInt($(this).css("line-height")) + 2*parseInt($(this).css("padding-top")) + 6) + "px" )
