module = angular.module 'FridaySheriff.services.auth'

module.service 'AuthService', ($http) ->

    @isAuthenticated = () ->
        data = @getCurrent()

        if data
            return true

        return

    @isAdmin = () ->
        data = @getCurrent()

        if data
            if data.user.roles[0] == 'admin'
                return true

        return false

    @getCurrent = () ->
        $http
            method: 'GET'
            url: '/api/user/current'
        .success (data, status, headers, config) ->
            return data
        .error (data, status, headers, config) ->
            return false
        return

    return
