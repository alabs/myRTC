
$(function () {

  if ($("body#rtc-enabled").length) {
    // create our webrtc connection
    var webrtc = new SimpleWebRTC({
        // the id/element dom element that will hold "our" video
        localVideoEl: 'localVideo',
        // the id/element dom element that will hold remote videos
        remoteVideosEl: 'remotes',
        // immediately ask for camera access
        autoRequestMedia: true,
        log: true
    });
  
    // create the room in the provider
    var room = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
    webrtc.createRoom(room);
    // when it's ready, join 
    webrtc.on('readyToCall', function () {
        // you can name it anything
        webrtc.joinRoom(room);
    });
  }

});
