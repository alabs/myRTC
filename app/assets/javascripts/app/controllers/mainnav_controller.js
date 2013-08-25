'use strict';

angular.module('myRTC')
  .controller('MainNavCtrl', ['$scope', function ($scope) {

  	$scope.removeLink = function() {
  		$("#mainNav > li").removeClass("active");
  	}
  	
  	$scope.setLink = function(item) {
  		$("#mainNav > li").removeClass("active");
  		$("#" + item).addClass("active");
  	}

  }]);

