$ ->
  if $("body#rtc-enabled").length
    webrtc = new SimpleWebRTC(
      localVideoEl: "localVideo"
      remoteVideosEl: "remotes"
      autoRequestMedia: true
      log: true
    )
    room = window.location.href.substring(window.location.href.lastIndexOf("/") + 1)
    webrtc.createRoom room
    webrtc.on "readyToCall", ->
      webrtc.joinRoom room