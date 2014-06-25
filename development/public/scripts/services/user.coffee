module = angular.module 'MEAN.services.user'

module.service 'UserService', ($http) ->

  @current = {}

  getCurrent: () ->
    $http.get '/api/user/current/'
