createRoom = ->
  $.post "/rooms",
    'room[name]': $('#js-room-name').val()
    (data, textStatus, jqXHR) -> window.location = '/rooms/' + data.name
    "json"

generateRandomString = ->
  return Math.random().toString(36).substring(7)

showAdvancedOptions = ->
  $('.js-show-advanced-link').hide()
  $('.js-show-advanced-section').show().removeClass('hide')

$ ->
  $('#js-room-name').val(generateRandomString()) if $('#js-room-name').length > 0
  $('.js-show-advanced-link').click ->
    showAdvancedOptions()
  $('.js-create-room-final').click ->
    createRoom()