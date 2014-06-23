module = angular.module 'MEAN.services.auth'

module.service 'AuthService', ($http) ->

    @user = {}

    signUp: (user) ->
        promise = $http.post '/api/user/signup/', JSON.stringify {email: user.email, password: user.password, name: user.name}
            .success (data) ->
                console.log data
                return
            .error (data) ->
                console.log data
                return
        return promise
