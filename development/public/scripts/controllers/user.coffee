module = angular.module 'MEAN.controllers.user'

module.controller 'UserController', ($scope, $state, UserService, AuthService) ->

  $scope.UserService = UserService
  $scope.AuthService = AuthService

  @init = () ->
    $scope.getCurrent()

    console.log $state

    if $state.params.email?
      $scope.getUser $state.params.email
    return

  $scope.getCurrent = () ->
    $scope.UserService.getCurrent()
      .success (data) ->
        $scope.UserService.current = data.user
        $scope.UserService.user = data.user
        return
      .error (data) ->
        # TODO : Error
        console.log data
        return
    return

  $scope.getUser = (email) ->
    $scope.UserService.getUser email
      .success (data) ->
        $scope.UserService.user = data.user
        return
      .error (data) ->
        # TODO : Error
        console.log data
        return
    return

  return @init()
