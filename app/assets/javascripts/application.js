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
//= require simplewebrtc
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

  $('#js-theme-switcher').on('change', function(){
    $('#js-style-theme').remove();
    $('head').append('<link id="js-style-theme" href="//netdna.bootstrapcdn.com/bootswatch/3.0.0/'+ this.value +'/bootstrap.min.css" rel="stylesheet">');
  });

});
