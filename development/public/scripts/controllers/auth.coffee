module = angular.module 'MEAN.controllers.auth'

module.controller 'AuthController', ($scope, $state, AuthService, AlertService) ->

  $scope.AuthService = AuthService
  $scope.AlertService = AlertService

  $scope.signUp = () ->

    if $scope.signUpForm.$valid
      if $scope.signUpForm.user.password is $scope.signUpForm.user.password_confirmation
        $scope.AuthService.signUp $scope.signUpForm.user
          .success (data) ->
            # TODO : Event for main controller
            $scope.signUpForm.user = {}
            $scope.AlertService.add 'success', data.message
            return
          .error (data) ->
            $scope.signUpForm.user.password = ''
            $scope.signUpForm.user.password_confirmation = ''
            $scope.signUpForm.password.$pristine = true
            $scope.signUpForm.password_confirmation.$pristine = true
            $scope.AlertService.add 'danger', data.message
            return
      else
        $scope.signUpForm.password_confirmation.match = false
    else
      if $scope.signUpForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter e-mail and password.'
        $scope.signUpForm.user.password = ''
        $scope.signUpForm.user.password_confirmation = ''
        $scope.signUpForm.password.$pristine = true
        $scope.signUpForm.password_confirmation.$pristine = true

    return

  $scope.signIn = () ->
    if $scope.signInForm.$valid
      $scope.AuthService.signIn $scope.signInForm.user
        .success (data) ->
          # TODO : Event for main controller
          $scope.signInForm.user = {}
          $scope.AlertService.add 'success', data.message
          return
        .error (data) ->
          $scope.signInForm.user.password = ''
          $scope.signInForm.password.$pristine = true
          $scope.AlertService.add 'danger', data.message
          return
    else
      if $scope.signInForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter e-mail and password.'

      if $scope.signInForm.user?
        $scope.signInForm.user.password = ''
        $scope.signInForm.password.$pristine = true

    return

  $scope.forgottenPassword = () ->

    if $scope.forgottenPasswordForm.$valid
      $scope.AuthService.forgottenPassword $scope.forgottenPasswordForm.user
        .success (data) ->
          $scope.AlertService.add 'success', data.message
          return
        .error (data) ->
          $scope.AlertService.add 'danger', data.message
          return
    else
      if $scope.forgottenPasswordForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter e-mail.'

    return

  $scope.resetPassword = () ->

    if $scope.resetPasswordForm.$valid
      if $scope.resetPasswordForm.user.password is $scope.resetPasswordForm.user.password_confirmation
        $scope.resetPasswordForm.user.token = $state.params.forgotCode

        $scope.AuthService.resetPassword $scope.resetPasswordForm.user
          .success (data) ->
            $scope.AlertService.add 'success', data.message
            $scope.resetPasswordForm.user = {}
            return
          .error (data) ->
            $scope.AlertService.add 'danger', data.message
            $scope.resetPasswordForm.user = {}
            return
      else
        $scope.resetPasswordForm.password_confirmation.match = false
    else
      if $scope.resetPasswordForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter password.'

    return

  return
