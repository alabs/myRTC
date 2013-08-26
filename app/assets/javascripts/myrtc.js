$(function () {


    // ejecutar en la página de la conferenncia
    if ($("body#rtc-enabled").length) {
  		var hash = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
  
      function initConnection(config) {
          window.connection = new RTCMultiConnection(hash, {
              firebase: 'rtcweb',
              session: 'audio-video',
              direction: 'many-to-many'
          });
          connection.onstream = function (stream) {
              var video = getVideo(stream);
              if (stream.type === 'local') document.getElementById('localVideo').appendChild(video);
  
              if (stream.type === 'remote') {
                  var remoteMediaStreams = document.getElementById('remotes');
                  remoteMediaStreams.appendChild(video, remoteMediaStreams.firstChild);
              }
              stream.mediaElement.width = innerWidth / 3.4;
          };

         connection.onleave = function (userid) {
             var mediaElement = document.getElementById(userid);
             if (mediaElement && mediaElement.parentNode) mediaElement.parentNode.parentNode.removeChild(mediaElement.parentNode);
         };
      }
      
      new window.Firebase('https://rtcweb.firebaseIO.com/' + hash).once('value', function (data) {
          var isRoomPresent = data.val() != null;
          if (isRoomPresent) {
            initConnection();
            window.isRoomInitiator = false;
          } else {
            initConnection();
            connection.open(); 
            window.isRoomInitiator = true;
          }
      });

      function getVideo(stream) {

          var div = document.createElement('div');
          div.className = 'video-container';
          div.id = stream.userid || 'self';
  
          //stream.mediaElement.controls = true;
          stream.mediaElement.autoplay = true;
          div.appendChild(stream.mediaElement);

          return div
      }
  



    }

});
