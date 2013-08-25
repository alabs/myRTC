'use strict';

angular.module('myRTC', [])
	.run(["$rootScope", function($rootScope) {
		// You can turn this off on production.
  		$rootScope.$debugMode = "on"; // "off"
	}]);

//'use strict';

//angular.module('myFeeds', [])
//	.run(["$rootScope", "$state", "$stateParams", function($rootScope, $state, $stateParams) {
//		// You can turn this off on production.
//  		$rootScope.$debugMode = "on"; // "off"
//
//		// Capture current state and stateParams, this variable can be showed
//  		// in browser for debug purpose.
//  		$rootScope.$state = $state;
//  		$rootScope.$stateParams = $stateParams;
//	}]);
