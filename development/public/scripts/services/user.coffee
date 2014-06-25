module = angular.module 'MEAN.services.user'

module.service 'UserService', ($http, $state) ->
  @current = {}
  @user = {}

  getCurrent: () ->
    $http.get '/api/user/current/'

  getUser: (email) ->
    $http.get '/api/user/'+email
