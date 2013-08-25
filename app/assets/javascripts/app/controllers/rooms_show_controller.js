'use strict';

angular.module('myRTC')
	.controller('RoomsShowCtrl', ['$scope', '$routeParams', 'RoomFactory',
		function($scope, $routeParams, RoomFactory) {

		// Grab the room from the server
		$scope.room = RoomFactory.get({id: $routeParams.name});
	}]);
