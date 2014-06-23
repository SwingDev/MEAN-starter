MEAN = angular.module 'MEAN', ['ui.router', 'MEAN.services']

MEAN.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/'

    $stateProvider
        .state 'home',
            url: '/'
            views:
                'main':
                    templateUrl: 'partials/home.html'
            authenticate: false
        .state 'signup',
            url: '/signup'
            views:
                'main':
                    templateUrl: 'partials/signup.html'
            constroller: 'AuthController'
            authenticate: false
        .state 'signin',
            url: '/signin'
            views:
                'main':
                    templateUrl: 'partials/signin.html'
            controller: 'AuthController'
            authenticate: false
        .state 'forgotten-password',
            url: '/forgotten-password'
            views:
                'main':
                    templateUrl: 'partials/forgotten-password.html'
            controller: 'AuthController'
            authenticate: false
        .state 'reset-password',
            url: '/reset-password/{forgot-code}'
            views:
                'main':
                    templateUrl: 'partials/reset-password.html'
            controller: 'AuthController'
            authenticate: false
        .state 'profile',
            url: '/profile'
            views:
                'main':
                    templateUrl: 'partials/profile.html'
            controller: 'UserController'
            authenticate: true
    return

MEAN.run ($rootScope, $state, AuthService) ->
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
        if toState.authenticate and not AuthService.isAuthenticated()
            $state.transitionTo 'signin'
            event.preventDefault()
        return
    return


angular.module 'MEAN.services', ['MEAN.services.auth']
angular.module 'MEAN.services.auth', []
