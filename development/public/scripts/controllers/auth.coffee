module = angular.module 'MEAN.controllers.auth'

module.controller 'AuthController', ($scope, $state, AuthService) ->

  $scope.AuthService = AuthService

  $scope.signUp = () ->

    if $scope.signUpForm.$valid
      if $scope.signUpForm.user.password is $scope.signUpForm.user.password_confirmation
        $scope.AuthService.signUp $scope.signUpForm.user
          .success (data) ->
            # TODO : Success
            $scope.signUpForm.user = {}
            console.log data
            return
          .error (data) ->
            # TODO : Error
            $scope.signUpForm.user.password = ''
            $scope.signUpForm.user.password_confirmation = ''
            console.log data
            return
      else
        # TODO : Wrong password confirmation
        $scope.signUpForm.user.password = ''
        $scope.signUpForm.user.password_confirmation = ''
    else
      # TODO : Invalid form data
      $scope.signUpForm.user.password = ''
      $scope.signUpForm.user.password_confirmation = ''

  return

  $scope.signIn = () ->

    if $scope.signInForm.$valid
      $scope.AuthService.signIn $scope.signInForm.user
        .success (data) ->
          # TODO : Success
          $scope.signInForm.user = {}
          console.log data
          return
        .error (data) ->
          # TODO : Error
          $scope.signInForm.user.password = ''
          console.log data
          return
    else
      # TODO : Invalid form data
      $scope.signInForm.user.password = ''

    return

  $scope.forgottenPassword = () ->

    if $scope.forgottenPasswordForm.$valid
      $scope.AuthService.forgottenPassword $scope.forgottenPasswordForm.user
        .success (data) ->
          # TODO : Success
          console.log data
          return
        .error (data) ->
          # TODO : Error
          console.log data
          return
    else
      # TODO : Invalid form data

    return

  $scope.resetPassword = () ->

    if $scope.resetPasswordForm.$valid
      if $scope.resetPasswordForm.user.password is $scope.resetPasswordForm.user.password_confirmation
        $scope.resetPasswordForm.user.token = $state.params.forgotCode

        $scope.AuthService.resetPassword $scope.resetPasswordForm.user
          .success (data) ->
            # TODO : Success
            $scope.resetPasswordForm.user = {}
            console.log data
            return
          .error (data) ->
            # TODO : Error
            $scope.resetPasswordForm.user = {}
            console.log data
            return
      else
        # TODO : Wrong password confirmation
        $scope.resetPasswordForm.user = {}
    else
      # TODO : Invalid form data

    return

  return
