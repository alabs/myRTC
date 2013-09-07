$ ->
  $('.js-open-pad').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.js-pad-wrapper').hide()
    $('.js-pad-wrapper').append ->
      hash = window.location.href.substring(window.location.href.lastIndexOf("/") + 1)
      '<iframe src="https://pad.alabs.es/p/' + hash + '?showChat=false&showLineNumbers=false" width="100%" height="400" frameborder="1"></iframe>'
    $('.js-pad-wrapper').slideDown(2000)
