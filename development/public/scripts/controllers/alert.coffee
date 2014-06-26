module = angular.module 'MEAN.controllers.alert'

module.controller 'AlertController', ($scope, AlertService) ->

  $scope.AlertService = AlertService

  $scope.closeAlert = AlertService.closeAlert

  return
