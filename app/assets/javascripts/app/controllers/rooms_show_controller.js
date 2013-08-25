'use strict';

angular.module('myRTC')
	.controller('RoomsShowCtrl', ['$scope', '$routeParams', 'RoomFactory',
		function($scope, $routeParams, RoomFactory) {

		// Grab the room from the server
		$scope.room = RoomFactory.get({id: $routeParams.name});

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
  
    var room = $routeParams.name;
    console.log(room);
    webrtc.createRoom(room);
  
    // when it's ready, join if we got a room from the URL
    webrtc.on('readyToCall', function () {
        // you can name it anything
        webrtc.joinRoom(room);
    });

	}]);
