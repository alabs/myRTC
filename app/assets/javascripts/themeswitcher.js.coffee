$ ->
  $("#js-theme-switcher").on "change", ->
    $("#js-style-theme").remove()
    $("head").append "<link id=\"js-style-theme\" href=\"//netdna.bootstrapcdn.com/bootswatch/3.0.0/" + @value + "/bootstrap.min.css\" rel=\"stylesheet\">"