'use strict';

angular.module('myRTC')
	.controller('RoomsCtrl', ['$scope', 'RoomFactory', function($scope, RoomFactory) {

		// Traer todas las rooms del backend
		$scope.rooms = RoomFactory.query();
	}]);
