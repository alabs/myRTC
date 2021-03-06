
generateRandomString = ->
  return Math.random().toString(36).substring(7)

showAdvancedOptions = ->
  $('.js-show-advanced-link').hide()
  $('.js-show-advanced-section').show().removeClass('hide')

shareOnFacebook = ->
  FB.ui
    method: "send"
    link: window.location.href

$ ->
  $('#js-room-name').val(generateRandomString()) if $('#js-room-name').length > 0
  # click click click
  $('.js-show-advanced-link').click ->
    showAdvancedOptions()
  $('.js-share-fb').click ->
    shareOnFacebook()
