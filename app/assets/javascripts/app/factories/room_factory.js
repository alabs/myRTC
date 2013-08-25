'use strict';

angular.module('myRTC')
	.factory('RoomFactory', ['$resource', function($resource) {

		return $resource('/api/rooms/:id', {id: '@id'});
	}]);