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
            if $scope.signUpForm.user?
              $scope.signUpForm.user.password = ''
              $scope.signUpForm.password.$pristine = true
              $scope.signUpForm.user.password_confirmation = ''
              $scope.signUpForm.password_confirmation.$pristine = true
            $scope.AlertService.add 'danger', data.message
            if data.errors?
              $scope.signUpForm.validationErrors = []
              angular.forEach data.errors, (value, key) ->
                if $scope.signUpForm.validationErrors[value.param] is undefined || $scope.signUpForm.validationErrors[value.param] is null
                  $scope.signUpForm.validationErrors[value.param] = []
                $scope.signUpForm.validationErrors[value.param].push {message: value.msg}
                return
            return
      else
        $scope.signUpForm.password_confirmation.match = false
    else
      if $scope.signUpForm.email.$pristine || $scope.signUpForm.password.$pristine || $scope.signUpForm.password_confirmation.$pristine
        $scope.AlertService.add 'danger', 'Please enter e-mail and password.'
        if $scope.signUpForm.user?
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
          if $scope.signInForm.user?
            $scope.signInForm.user.password = ''
          $scope.signInForm.password.$pristine = true
          $scope.AlertService.add 'danger', data.message
          if data.errors?
            $scope.signInForm.validationErrors = []
            angular.forEach data.errors, (value, key) ->
              if $scope.signInForm.validationErrors[value.param] is undefined || $scope.signInForm.validationErrors[value.param] is null
                $scope.signInForm.validationErrors[value.param] = []
              $scope.signInForm.validationErrors[value.param].push {message: value.msg}
              return
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
          if data.errors?
            $scope.forgottenPasswordForm.validationErrors = []
            angular.forEach data.errors, (value, key) ->
              if $scope.forgottenPasswordForm.validationErrors[value.param] is undefined || $scope.forgottenPasswordForm.validationErrors[value.param] is null
                $scope.forgottenPasswordForm.validationErrors[value.param] = []
              $scope.forgottenPasswordForm.validationErrors[value.param].push {message: value.msg}
              return
          return
    else
      if $scope.forgottenPasswordForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter e-mail.'

    return

  $scope.resetPassword = () ->

    if $scope.resetPasswordForm.$valid
      if $scope.resetPasswordForm.user?
        if $scope.resetPasswordForm.user.password is $scope.resetPasswordForm.user.password_confirmation
          $scope.resetPasswordForm.user.token = $state.params.forgotCode

          $scope.AuthService.resetPassword $scope.resetPasswordForm.user
            .success (data) ->
              $scope.AlertService.add 'success', data.message
              $scope.resetPasswordForm.user = {}
              return
            .error (data) ->
              $scope.AlertService.add 'danger', data.message
              if data.errors?
                $scope.resetPasswordForm.validationErrors = []
                angular.forEach data.errors, (value, key) ->
                  if $scope.resetPasswordForm.validationErrors[value.param] is undefined || $scope.resetPasswordForm.validationErrors[value.param] is null
                    $scope.resetPasswordForm.validationErrors[value.param] = []
                  $scope.resetPasswordForm.validationErrors[value.param].push {message: value.msg}
                  return
              $scope.resetPasswordForm.user = {}
              return
        else
          $scope.resetPasswordForm.password_confirmation.match = false
      else
        $scope.AlertService.add 'danger', 'Please enter password.'
    else
      if $scope.resetPasswordForm.$pristine
        $scope.AlertService.add 'danger', 'Please enter password.'

    return

  return
