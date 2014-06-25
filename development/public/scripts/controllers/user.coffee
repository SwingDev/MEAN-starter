module = angular.module 'MEAN.controllers.user'

module.controller 'UserController', ($scope, $state, UserService, AuthService) ->

  $scope.UserService = UserService
  $scope.AuthService = AuthService

  @init = () ->
    $scope.getCurrent()

    if $state.params.email?
        $scope.getUser($state.params.email)
    return

  $scope.getCurrent = () ->

    $scope.UserService.getCurrent()
      .success (data) ->
        $scope.UserService.current = data.user
        return
      .error (data) ->
        # TODO : Error
        console.log data
        return

    return

  return @init()
