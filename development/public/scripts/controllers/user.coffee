module = angular.module 'MEAN.controllers.user'

module.controller 'UserController', ($scope, $state, UserService, AuthService, AlertService) ->

  $scope.UserService = UserService
  $scope.AuthService = AuthService
  $scope.AlertService = AlertService

  @init = () ->
    $scope.getCurrent()

    if $state.params.email? and $state.params.email != ''
      $scope.getUser $state.params.email
    return

  $scope.getCurrent = () ->
    $scope.UserService.getCurrent()
      .success (data) ->
        $scope.UserService.current = data.user
        $scope.UserService.user = data.user
        return
      .error (data) ->
        return
    return

  $scope.getUser = (email) ->
    $scope.UserService.getUser email
      .success (data) ->
        $scope.UserService.user = data.user
        return
      .error (data) ->
        $scope.AlertService.add 'danger', data.message
        return
    return

  $scope.updateUser = (user) ->
    $scope.UserService.updateUser user
      .success (data) ->
        $scope.UserService.user = user
        $scope.AlertService.add 'success', data.message
        return
      .error (data) ->
        $scope.AlertService.add 'danger', data.message
        return
    return

  return @init()
