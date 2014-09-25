'use strict'

###*
 # @ngdoc function
 # @name bardDocUiApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the bardDocUiApp
###
angular.module('bardDocUiApp')
  .controller 'MainCtrl', ($scope, $http, $location, $anchorScroll) ->
    $scope.api = "http://localhost:8080/api-doc"

    $scope.getDoc = (url) ->
      $http.get(url).success (data) ->
        $scope.doc = data

    $scope.toApi = (i) ->
      $location.hash("api_#{i}")
      $anchorScroll()
