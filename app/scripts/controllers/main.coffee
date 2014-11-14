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
  .config ($locationProvider) ->
    $locationProvider.html5Mode(true)
  .controller 'MainCtrl', ($scope, $http, $location, $anchorScroll) ->
    $scope.api = $location.search().host || "http://crud.example.bardframework.com";

    $scope.getDoc = (url) ->
      $http.get("#{url}/api-doc").success (data) ->
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

    $scope.getId = (property) ->
      return false unless property?
      return null unless property?.id || property?.$ref
      return property?.id || property?.$ref

    $scope.getDoc($scope.api)
