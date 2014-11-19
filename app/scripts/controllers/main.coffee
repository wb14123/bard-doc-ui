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

    $scope.tryApis = []

    $scope.toggleTryApi = (index, api) ->
      $scope.tryApis[index] = {}
      $scope.tryApis[index].request = {}
      $scope.tryApis[index].request.header = {}
      $scope.tryApis[index].request.url= {}
      $scope.tryApis[index].request.path = {}
      $scope.tryApis[index].request.form = {}
      $scope.tryApis[index].request.multipart = {}
      $scope.tryApis[index].request.method = "GET"
      $scope.tryApis[index].request.contentType = ""
      $scope.tryApis[index].request.requestUrl = ""
      $scope.tryApis[index].tryApi = true
      if api?
        $scope.tryApis[index].request.requestUrl = $scope.api + api.path
        $scope.tryApis[index].request.method = api.method
        $scope.tryApis[index].tryApi = true
      else
        $scope.tryApis[index].tryApi = false

    $scope.sendAPIRequest = (index) ->
      $("#tryResponseBody").text("Waiting for response...")
      request = new XMLHttpRequest()
      request.onload = ->
        # TODO: what if the response is not json??
        $("#tryResponseBody").text(JSON.stringify(JSON.parse(@responseText),null,2))

      $scope.request = $scope.tryApis[index].request
      url = $scope.request.requestUrl

      first = true
      for k, v of $scope.request.url
        if first
          url += "?#{k}=#{v}"
          first = false
        else
          url += "&#{k}=#{v}"

      for k, v of $scope.request.path
        regex = new RegExp("\{#{k}(:.*)*\}")
        url = url.replace(regex, v)

      request.open($scope.request.method, url, true)
      for k, v of $scope.request.header
        request.setRequestHeader(k, v)

      params = null
      if ! $.isEmptyObject($scope.request.form)
        request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        params = ""
        first = true
        for k, v of $scope.request.form
          if first
            params += "#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"
            first = false
          else
            params += "&#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"

      isForm = false

      if ! $.isEmptyObject($scope.request.multipart)
        isForm = true
        formData = new FormData()
        for k, v of $scope.request.multipart
          formData.append(k, v)
        params = formData

      fileParams = $(".file_#{index}").not('.ng-hide')
      if fileParams.length > 0
        isForm = true
        for f in fileParams
          formData = params || new FormData()
          formData.append(f.name, f.files[0], f.files[0].name)
        params = formData

      if ! isForm
        request.setRequestHeader("Content-Type", $scope.request.contentType)
      request.send(params)

    $scope.isFile = (property) ->
      id = $scope.getId(property)
      return false unless id
      return id.indexOf("FileItem") > -1

    $scope.getDoc($scope.api)
