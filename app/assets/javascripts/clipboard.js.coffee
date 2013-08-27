$ ->
  clip = new ZeroClipboard($(".js-copyclip"))
  clip.on "complete", (client, args) ->
    $(".js-copyclip-alert").show(500).removeClass "hide"