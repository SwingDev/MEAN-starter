module = angular.module 'MEAN.services.alert'

module.service 'AlertService', () ->

  alerts: []

  add: (type, message) ->
    @alerts.push
      type: type
      message: message
    return

  closeAlert: (index) ->
    @alerts.splice index, 1
    return
