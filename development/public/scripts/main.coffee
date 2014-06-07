# FridaySheriff = angular.module 'FridaySheriff', ['ui.router', 'FridaySheriff.services']

# FridaySheriff.config ($stateProvider, $urlRouterProvider) ->
#     $urlRouterProvider.otherwise '/dashboard'

#     $stateProvider
#         .state 'dashboard',
#             url: '/dashboard'
#             templateUrl: 'partials/dashboard.html'
#             controller: 'DashboardController'
#             authenticate: true
#         .state 'admin',
#             url: '/admin'
#             templateUrl: 'partials/admin.html'
#             controller: 'AdminController'
#             authenticate: 'admin'
#         .state 'signin',
#             url: '/signin'
#             templateUrl: 'partials/signin.html'
#             controller: 'SignInController'
#     return

# FridaySheriff.run ($rootScope, $state, AuthService) ->
#     $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
#         if toState.authenticate and not AuthService.isAuthenticated()
#             $state.transitionTo 'signin'
#             event.preventDefault()
#         return
#     return


# angular.module 'FridaySheriff.services', ['FridaySheriff.services.auth']
# angular.module 'FridaySheriff.services.auth', []
