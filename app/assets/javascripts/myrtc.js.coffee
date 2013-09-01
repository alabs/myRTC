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

appendChatMsg = (data, user) ->
  chatOutput = document.getElementById('chat-output')
  chatInput = document.getElementById('chat-input')
  div = document.createElement('div')
  div.innerHTML = '<div class="chat-msg"><strong>'+user+'</strong><span class="chat-delim">: </span><span class="chat-text">'+data+'</span></div>'
  chatOutput.insertBefore(div, chatOutput.firstChild)
  div.tabIndex = 0
  div.focus()
  chatInput.focus()

percentProgressBar = (total, counter) ->
  (counter/total) * 100

appendProgressBar = (total, remaining) ->
  $("#file-progress > div").remove()
  counter = (total - remaining)
  $("#file-progress")
    .append('<div class="progress-bar" role="progressbar" aria-valuenow="'+counter+'" aria-valuemin="0" aria-valuemax="'+total+'" style="width: '+percentProgressBar(total, counter)+'%"></div>')
  counter++

removeProgressBar = ->
  $(".progress-bar").remove()

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
      connection.onmessage = (msg) ->
        appendChatMsg(msg, 'anon')
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
      # sending/received files
      connection.autoSaveToDisk = false
      connection.onFileProgress = (packets) ->
        appendProgressBar(packets.length, packets.remaining)
      connection.onFileSent = (file) ->
        removeProgressBar()
        $("#file").val("")
        appendChatMsg('Le llegó el fichero', 'bot')
      connection.onFileReceived = (filename) ->
        removeProgressBar()
        appendChatMsg('Te llegó un fichero', 'bot')
      document.getElementById('file').onchange = ->
        connection.send(this.files[0])
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
      connection.send(this.value)
      appendChatMsg(this.value, 'anon')
      chatInput.value = ''
      chatInput.focus()
