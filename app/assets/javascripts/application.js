// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
// require angular
// require angular-resource
// require simplewebrtc
//= require firebase
//= require RTCMultiConnection-v1.2
//= require rtc-commons
// require app/utilities/main
// require app/main
// require app/factories/room_factory
// require app/controllers/mainnav_controller
// require app/controllers/home_controller
// require app/controllers/users_controller
// require app/controllers/rooms_controller
// require app/controllers/rooms_show_controller
// require app/controllers/contact_controller
// require_tree .
//= require rooms
//= require_self

$(function () {

    $('#js-theme-switcher').on('change', function(){
      $('#js-style-theme').remove();
      $('head').append('<link id="js-style-theme" href="//netdna.bootstrapcdn.com/bootswatch/3.0.0/'+ this.value +'/bootstrap.min.css" rel="stylesheet">');
    });


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
              //stream.mediaElement.width = innerWidth / 3.4;
              stream.mediaElement.width = 275;
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
