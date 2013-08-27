
checkWebRTCSupport = ->
  navigator.getUserMediaMyRTC = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia
  window.URL = window.URL or window.webkitURL or window.mozURL or window.msURL
  unless navigator.getUserMediaMyRTC
    $('.js-no-webrtc').removeClass('hide').show() 
    $('.js-accept-webrtc').hide()

$ ->
  checkWebRTCSupport()
  if $("body#rtc-enabled").length
    initConnection = (config) ->
      window.connection = new RTCMultiConnection(hash,
        firebase: "rtcweb"
        session: "audio-video"
        direction: "many-to-many"
      )
      connection.onstream = (stream) ->
        $(".js-accept-webrtc").hide()
        video = getVideo(stream)
        document.getElementById("localVideo").appendChild video  if stream.type is "local"
        if stream.type is "remote"
          remoteMediaStreams = document.getElementById("remotes")
          remoteMediaStreams.appendChild video, remoteMediaStreams.firstChild
        stream.mediaElement.width = innerWidth / 3.4

      connection.onleave = (userid) ->
        mediaElement = document.getElementById(userid)
        mediaElement.parentNode.parentNode.removeChild mediaElement.parentNode  if mediaElement and mediaElement.parentNode
    getVideo = (stream) ->
      div = document.createElement("div")
      div.className = "video-container"
      div.id = stream.userid or "self"
      stream.mediaElement.autoplay = true
      div.appendChild stream.mediaElement
      div
    hash = window.location.href.substring(window.location.href.lastIndexOf("/") + 1)
    new window.Firebase("https://rtcweb.firebaseIO.com/" + hash).once "value", (data) ->
      isRoomPresent = data.val()?
      if isRoomPresent
        initConnection()
        window.isRoomInitiator = false
      else
        initConnection()
        connection.open()
        window.isRoomInitiator = true