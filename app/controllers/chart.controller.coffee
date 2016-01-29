app = angular.module 'analyzer'


chartController = ($scope, $http) ->
  initChart = (path) ->
    $http({
      url: '/chart', 
      method: 'GET',
      params: {path: path}
    }).then (resp) ->
      data = resp.data
      whiteMin = 20
      whiteMax = 80
      chart = new Highcharts.Chart {
        chart: {
          renderTo: 'chart',
          type: 'column'
        },
        title: {
          text: 'Statistics of components usage'
        },
        xAxis: {
          categories: data.map (element) -> element.name
          title: {
            text: 'Component'
          }
        },
        yAxis: {
          title: {
            text: 'Count of lines'
          }
        },

        legend: {
          enabled: false
        },

        series: [
          name: 'component',
          data: data.map (element) ->
            value = whiteMax - element.usagePlaces.length * 10
            if value < whiteMin then value = whiteMin
            {
              y: element.linesCount,
              color: 'hsl(209, 90%, ' + value + '%)'
            }
        ],
        tooltip: {
          formatter: ->
            names = data.map (element) -> element.name
            index = names.indexOf this.x
            if data[index].usagePlaces.length
              usage = this.x + ' is injected by: ' + data[index].usagePlaces.join(', ')
            else 
              usage = this.x + ' is not injected anywhere'
            
            usage + '<br>' + 'Type of component: ' + data[index].type

        }
      }

  $scope.showChart = -> 
    console.log $scope.path
    initChart $scope.path

app.controller 'ChartController', chartController
chartController.$inject = ['$scope', '$http']
