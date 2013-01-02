# vim:syntax=coffee:
jQuery ->
  jQuery.validator.addMethod("datetime", (value, element) ->
    return this.optional(element) || /^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}$/i.test(value)
  , "A valid date and time is required.")
  $('form.validatable').validate()
  $('input[type=text]').not(".datetime").change ->
    $('form.validatable').validate()
