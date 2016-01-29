app = angular.module 'analyzer'

app.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise 'dir'

  $stateProvider
    .state('dir', {
      url: '/',
      tamplateUrl: 'dir.tpl.html',
      controller: 'DirController'
    })
    .state('chart', {
      url: '/chart',
      templateUrl: 'chart.tpl.html',
      controller: 'ChartController'
    })
]
