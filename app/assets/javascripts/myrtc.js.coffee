
hash = window.location.href.substring(window.location.href.lastIndexOf("/") + 1)

###
cookies
###

setCookie = (c_name, value, exdays) ->
  exdate = new Date()
  exdate.setDate exdate.getDate() + exdays
  c_value = escape(value) + ((if (not (exdays?)) then "" else "; expires=" + exdate.toUTCString()))
  document.cookie = c_name + "=" + c_value

getCookie = (c_name) ->
  i = undefined
  x = undefined
  y = undefined
  ARRcookies = document.cookie.split(";")
  i = 0
  while i < ARRcookies.length
    x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="))
    y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1)
    x = x.replace(/^\s+|\s+$/g, "")
    return unescape(y)  if x is c_name
    i++

###
myrtc-support 
###
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

###
myrtc-videos
###

checkVideosSizes = ->
  $remotes = $('#remotes video')
  switch $remotes.size()
    when 1 then $remotes.attr('width', '100%')
    when 2 then $remotes.attr('width', '50%')
    when 3 then $remotes.attr('width', '33%')
    else $remotes.attr('width', '33%')

initVideo = (stream) ->
  $(".js-accept-webrtc").hide()
  video = getVideo(stream)
  document.getElementById("localVideo").appendChild video  if stream.type is "local"
  if stream.type is "remote"
    remoteMediaStreams = document.getElementById("remotes")
    remoteMediaStreams.appendChild video, remoteMediaStreams.firstChild
  stream.mediaElement.width = innerWidth / 3.4

getVideo = (stream) ->
  div = document.createElement("div")
  div.className = "video-container"
  div.id = stream.userid or "self"
  stream.mediaElement.autoplay = true
  div.appendChild stream.mediaElement
  div

initConnection = (config) ->
  username = $('#chat-username').val() + ' <span>[' + getHMS() + ']</span>'
  window.connection = new RTCMultiConnection(hash,
    firebase: "myrtc"
    session: "audio-video-data"
    direction: "many-to-many"
  )
  connection.onmessage = (msg) ->
    appendChatMsg(chatInput, chatOutput, msg, username)
  connection.onstream = (stream) ->
    initVideo(stream)
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
    appendChatMsg(chatInput, chatOutput, 'Le llegó el fichero', 'bot')
  connection.onFileReceived = (filename) ->
    removeProgressBar()
    appendChatMsg(chatInput, chatOutput, 'Te llegó un fichero', 'bot')
  document.getElementById('file').onchange = ->
    connection.send(this.files[0])

### 
myrtc-chat
###

setRandomUser = ->
  $('#chat-username').val("anonymous-" + getRandomNumber())

getRandomNumber = ->
  Math.floor(Math.random()*111111)

pad = (n) ->
  ("0" + n).slice(-2)

getHMS = ->
  date = new Date
  seconds = pad(date.getSeconds())
  minutes = pad(date.getMinutes())
  hour = pad(date.getHours())
  hour + ':' + minutes + ':' + seconds

appendChatMsg = (chatInput, chatOutput, data, user) ->
  div = document.createElement('div')
  div.innerHTML = '<div class="chat-msg"><strong>'+user+'</strong><span class="chat-delim">: </span><span class="chat-text">'+data+'</span></div>'
  chatOutput.insertBefore(div, chatOutput.firstChild)
  #chatOutput.insertBefore(div, chatOutput.firstChild)
  div.tabIndex = 0
  div.focus()
  chatInput.focus()

initChatAndVideo = (chatInput, chatOutput, hash) ->
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
    username = $('#chat-username').val() + ' <span>[' + getHMS() + ']</span>'
    appendChatMsg(chatInput, chatOutput, this.value, username)
    chatInput.value = ''
    chatInput.focus()

###
myrtc-filetransfer
###

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

###
myrtc
###

$ ->
  if $("body#rtc-enabled").length
    checkWebRTCSupport()
    checkBrowserSupport()
    chatOutput = document.getElementById('chat-output')
    chatInput = document.getElementById('chat-input')
    setRandomUser()
    initChatAndVideo(chatInput, chatOutput, hash)
    setTimeout ( ->
      checkVideosSizes()
    ), 10000
    if getCookie("username") 
      $('#chat-username').val(getCookie("username"))
    else
      setCookie("username", $('#chat-username').val(), 30)
    checkUsernameTyping()
    true

checkUsernameTyping = ->
  typingTimer = undefined

  #on keyup, start the countdown
  $('#chat-username').keyup ->
    typingTimer = setTimeout(doneTyping, 2000)

  #on keydown, clear the countdown 
  $('#chat-username').keydown ->
    clearTimeout typingTimer

#user is "finished typing," do something
doneTyping = ->
  username = $('#chat-username').val()
  setCookie("username", username, 30)
  $('.js-alerts-wrapper').prepend '<div class="alert alert-success hide js-username-changed">We have changed your name to ' + username + '</div>'
  $('.js-username-changed').removeClass('hide').slideDown(500)
  setTimeout ( ->
    $('.js-username-changed').slideUp()
  ), 5000
  
# $('#chat-username').bind 'input', ->
#   username = $('#chat-username').val()
#   setCookie("username", username, 30)
#   $('.js-alerts-wrapper').prepend '<div class="alert alert-success hide js-username-changed">We have changed your name to ' + username + '</div>'
#   $('.js-username-changed').removeClass('hide').slideDown(500)
#   setTimeout ( ->
#     $('.js-username-changed').slideUp()
#   ), 5000
