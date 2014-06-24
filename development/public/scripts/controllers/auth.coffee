module = angular.module 'MEAN.controllers.auth'

module.controller 'AuthController', ($scope, AuthService) ->

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
                        console.log data
                        return
            else
                # TODO : Wrong password confirmation
        else
            # TODO : Invalid form data

        $scope.signUpForm.user.password = ''
        $scope.signUpForm.user.password_confirmation = ''

        return

    return
