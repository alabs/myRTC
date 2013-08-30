showAlertUnsupported = ->
  $('.js-no-webrtc').removeClass('hide').show()
  $('.js-accept-webrtc').hide()

checkWebRTCSupport = ->
  # hacer el check de DataConnection
  navigator.getUserMediaMyRTC = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia
  window.URL = window.URL or window.webkitURL or window.mozURL or window.msURL
  unless navigator.getUserMediaMyRTC
    showAlertUnsupported()

checkBrowserSupport = ->
  is_firefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1
  is_android = navigator.userAgent.toLowerCase().indexOf('android') > -1
  if (is_firefox and is_android)
    showAlertUnsupported()

appendDIV = (data, parent) ->
  div = document.createElement('div')
  div.innerHTML = data
  chatOutput = document.getElementById('chat-output')
  fileProgress = document.getElementById('file-progress')
  if (!parent)
    chatOutput.insertBefore(div, chatOutput.firstChild)
  else
    fileProgress.insertBefore(div, fileProgress.firstChild)
  div.tabIndex = 0
  div.focus()
  chatInput.focus()


$ ->
  checkWebRTCSupport()
  checkBrowserSupport()
  if $("body#rtc-enabled").length
    initConnection = (config) ->
      window.connection = new RTCMultiConnection(hash,
        firebase: "myrtc"
        session: "audio-video-data"
        direction: "many-to-many"
      )
      connection.onmessage = (e) ->
        appendDIV(e)
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
    new window.Firebase("https://myrtc.firebaseio.com/" + hash).once "value", (data) ->
      isRoomPresent = data.val()?
      if isRoomPresent
        initConnection()
        window.isRoomInitiator = false
      else
        initConnection()
        connection.open()
        window.isRoomInitiator = true
    chatInput = document.getElementById('chat-input')
    chatInput.onkeypress = (e) ->
      if (e.keyCode != 13 || !this.value)
        return
      appendDIV(this.value);
      connection.send(this.value)

      this.value = ''
      this.focus()
