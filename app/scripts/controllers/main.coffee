'use strict'

###*
 # @ngdoc function
 # @name bardDocUiApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the bardDocUiApp
###

models = {}

angular.module('bardDocUiApp')
  .controller 'MainCtrl', ($scope, $http, $location, $anchorScroll) ->
    $scope.api = "http://crud.example.bardframework.com/api-doc"

    $scope.getDoc = (url) ->
      $http.get(url).success (data) ->
        i = 0
        for id,model of data.models
          data.models[id].index = i
          models[id] = i
          i++
        $scope.doc = data

    $scope.toApi = (i) ->
      $location.hash("api_#{i}")
      $anchorScroll()

    $scope.toModel = (id) ->
      $location.hash("model_#{models[id]}")
      $anchorScroll()

    $scope.cleanId = (id) ->
      return id.replace("urn:jsonschema:", "")

    $scope.getDoc($scope.api)
