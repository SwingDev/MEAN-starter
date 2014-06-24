module = angular.module 'MEAN.services.auth'

module.service 'AuthService', ($http) ->

    @user = {}

    signUp: (user) ->
        $http.post '/api/user/signup/', JSON.stringify {email: user.email, password: user.password, name: user.name}

    signIn: (user) ->
        $http.post '/api/user/signin/', JSON.stringify user

    forgottenPassword: (user) ->
        $http.post '/api/user/forgot/', JSON.stringify user
