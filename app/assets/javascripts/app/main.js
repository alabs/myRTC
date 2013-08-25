'use strict';

angular.module('myRTC', ['ngResource'])
	.config(["$httpProvider", "$routeProvider", function($httpProvider, $routeProvider) {
		var authToken = $("meta[name=\"csrf-token\"]").attr("content");
		$httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;

		$routeProvider
			.when('/', {
				templateUrl: '/assets/app/views/pages/index.html',
				controller: 'HomeCtrl'
			})
			.when('/users', {
				templateUrl: '/assets/app/views/pages/users.html',
				controller: 'UsersCtrl'
			})
			.when('/rooms', {
				templateUrl: '/assets/app/views/rooms/index.html',
				controller: 'RoomsCtrl'
			})
			.when('/rooms/:name', {
				templateUrl: '/assets/app/views/rooms/show.html',
				controller: 'RoomsShowCtrl'
			})
			.when('/contact', {
				templateUrl: '/assets/app/views/pages/contact.html',
				controller: 'ContactCtrl'
			})
			.otherwise({
				redirectTo: '/'
			});
	}]);

