---
layout: post
title: "开源：Angularjs示例--Sonar中项目使用语言分布图(CoffeeScript版)"
description: "开源：Angularjs示例--Sonar中项目使用语言分布图(CoffeeScript版)"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 关于**[SonarLanguage](https://github.com/greengerong/SonarLanguage)**是什么东东，这里就不在描述了，如果你对它感兴趣的话，请移步到上篇随笔[开源：Angularjs示例--Sonar中项目使用语言分布图](http://www.cnblogs.com/whitewolf/archive/2012/12/02/2798001.html)。这里是最近学习CoffeeScript的练习版。

&nbsp;&nbsp;&nbsp;&nbsp; [CoffeeScript](http://coffeescript.org/)是一门简洁的，构架于JavaScript之上的预处理器语言，可以静态编译成JavaScript，语法主要受ruby和python影响，目前已经为众多rails和node项目采用。CoffeeScript不是JavaScript的超集，也不是完全替代品。CoffeeScript有点在于：

1.  更少，更紧凑，和更清晰的代码
2.  通过规避和改变对JavaScript中不良部分的使用，只留下精华，让代码减少出错率，更容易维护
3.  在很多常用模式的实现上采用了JavaScript中的最佳实践
4.  CoffeeScript生成的JavaScript代码都可以完全通过[JSLint](http://www.javascriptlint.com/)的检测

&nbsp;&nbsp; 多的也不想说那么多了，这里主要是个简介，CoffeeScript的练笔示例。

代码如下：

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;collapse:true;;gutter:true;">app = angular.module('app', [])

    .value("$host", "http://nemo.sonarsource.org")

    .factory("$requestUrl", ($host) -&gt; "#{$host}/api/resources")

    .factory("$dynamicColor", ($host) -&gt;

        [r,g,b] = [10,10,0]

        {

          getColor: -&gt;

               [r,g,b] = [(r+100), (g+400), (b + 200)]

               "##{(r + 256 * g + 65536 * b).toString 16 }"

          ,

          reset: -&gt; 

               [r,g,b] = [10,10,0] 

        };

    ).directive('chartData', -&gt; 

            drawChart = (elementId, data) -&gt; 

               chart = new AmCharts.AmPieChart() 

               chart.dataProvider = data

               chart.titleField = "name"

               chart.valueField = "percentage"

               chart.colorField = "color"

               chart.labelsEnabled = false

               chart.pullOutRadius = 0

               chart.depth3D = 20

               chart.angle = 45

               legend = new AmCharts.AmLegend()

               legend.makerType = "square"

               legend.align = "center"

               chart.addLegend legend

               chart.write elementId

               chart;

            (scope, element, attr) -&gt; 

                  scope.already.push( -&gt; 

                     data = scope.$eval(attr.chartData);

                     drawChart(element[0].id, data); 

                  ) if element[0].id 

    )

report = ($scope, $window, $http, $requestUrl, $dynamicColor) -&gt;

    $scope.already = []

    $window.angularJsonpCallBack = (data) -&gt;

         @data = data

         getObjectByKey = (msr , key) -&gt;

            m for m in msr when m.key == key 

         $scope.gridSource = $scope.projects = data

         ready = (queues) -&gt; angular.forEach(queues, (q) -&gt; q() ) 

         ready $scope.already 

    $scope.getLanguageChartData = -&gt; 

         data = _.groupBy $scope.projects , (project) -&gt; project.lang 

         $dynamicColor.reset()

         chartData = _.map(data, (array, key) -&gt; 

                      "name":key

                      "percentage":array.length,

                      "color":$dynamicColor.getColor())

         _.sortBy(chartData, (num) -&gt; num.percentage )

    $scope.search = -&gt;

        source = []

        if not this.searchName

            source = @projects

        else 

            source = _.filter @projects, (p) -&gt; 

                       p.name.toLowerCase().indexOf $scope.searchName.toLowerCase() != -1 

        source = _.sortBy(source, (p) -&gt; p[$scope.sortCondition.key].toLowerCase()) if @sortCondition and @sortCondition.key

        source.reverse() if @sortCondition.sort and not @sortCondition.sort[$scope.sortCondition.key] 

        @gridSource = source

    $scope.sort = (name) -&gt;

        @sortCondition ?= {}

        @sortCondition.sort ?= {}

        @sortCondition.key = name

        @sortCondition.sort[name] = not @sortCondition.sort[name]

        @search();

    $scope.init = -&gt;

        $http.jsonp "#{$requestUrl}?callback=angularJsonpCallBack"

app.controller "report", report
</pre>
</div>

最终编译的JavaScript为：

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;collapse:true;;gutter:true;">var app, report;

app = angular.module('app', []).value("$host", "http://nemo.sonarsource.org").factory("$requestUrl", function($host) {
  return "" + $host + "/api/resources";
}).factory("$dynamicColor", function($host) {
  var b, g, r, _ref;
  _ref = [10, 10, 0], r = _ref[0], g = _ref[1], b = _ref[2];
  return {
    getColor: function() {
      var _ref1;
      _ref1 = [r + 100, g + 400, b + 200], r = _ref1[0], g = _ref1[1], b = _ref1[2];
      return "#" + ((r + 256 * g + 65536 * b).toString(16));
    },
    reset: function() {
      var _ref1;
      return _ref1 = [10, 10, 0], r = _ref1[0], g = _ref1[1], b = _ref1[2], _ref1;
    }
  };
}).directive('chartData', function() {
  var drawChart;
  drawChart = function(elementId, data) {
    var chart, legend;
    chart = new AmCharts.AmPieChart();
    chart.dataProvider = data;
    chart.titleField = "name";
    chart.valueField = "percentage";
    chart.colorField = "color";
    chart.labelsEnabled = false;
    chart.pullOutRadius = 0;
    chart.depth3D = 20;
    chart.angle = 45;
    legend = new AmCharts.AmLegend();
    legend.makerType = "square";
    legend.align = "center";
    chart.addLegend(legend);
    chart.write(elementId);
    return chart;
  };
  return function(scope, element, attr) {
    if (element[0].id) {
      return scope.already.push(function() {
        var data;
        data = scope.$eval(attr.chartData);
        return drawChart(element[0].id, data);
      });
    }
  };
});

report = function($scope, $window, $http, $requestUrl, $dynamicColor) {
  $scope.already = [];
  $window.angularJsonpCallBack = function(data) {
    var getObjectByKey, ready;
    this.data = data;
    getObjectByKey = function(msr, key) {
      var m, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = msr.length; _i &lt; _len; _i++) {
        m = msr[_i];
        if (m.key === key) {
          _results.push(m);
        }
      }
      return _results;
    };
    $scope.gridSource = $scope.projects = data;
    ready = function(queues) {
      return angular.forEach(queues, function(q) {
        return q();
      });
    };
    return ready($scope.already);
  };
  $scope.getLanguageChartData = function() {
    var chartData, data;
    data = _.groupBy($scope.projects, function(project) {
      return project.lang;
    });
    $dynamicColor.reset();
    chartData = _.map(data, function(array, key) {
      return {
        "name": key,
        "percentage": array.length,
        "color": $dynamicColor.getColor()
      };
    });
    return _.sortBy(chartData, function(num) {
      return num.percentage;
    });
  };
  $scope.search = function() {
    var source;
    source = [];
    if (!this.searchName) {
      source = this.projects;
    } else {
      source = _.filter(this.projects, function(p) {
        return p.name.toLowerCase().indexOf($scope.searchName.toLowerCase() !== -1);
      });
    }
    if (this.sortCondition &amp;&amp; this.sortCondition.key) {
      source = _.sortBy(source, function(p) {
        return p[$scope.sortCondition.key].toLowerCase();
      });
    }
    if (this.sortCondition.sort &amp;&amp; !this.sortCondition.sort[$scope.sortCondition.key]) {
      source.reverse();
    }
    return this.gridSource = source;
  };
  $scope.sort = function(name) {
    var _base, _ref, _ref1;
    if ((_ref = this.sortCondition) == null) {
      this.sortCondition = {};
    }
    if ((_ref1 = (_base = this.sortCondition).sort) == null) {
      _base.sort = {};
    }
    this.sortCondition.key = name;
    this.sortCondition.sort[name] = !this.sortCondition.sort[name];
    return this.search();
  };
  return $scope.init = function() {
    return $http.jsonp("" + $requestUrl + "?callback=angularJsonpCallBack");
  };
};

app.controller("report", report);
</pre>
</div>

> 就这么多了，关于CoffeeScript请参考
> 
> 1.  [CoffeeScript](http://coffeescript.org/)
> 2.  [CoffeeScript详解](http://ruby-china.org/topics/4789)
> 3.  [CoffeeScript: The beautiful way to write JavaScript](http://amix.dk/blog/post/19612)
> 4.  [当jQuery遭遇CoffeeScript&mdash;&mdash;妙不可言](http://developer.51cto.com/art/201109/292065.htm)> 
> 
> 本人也会在随后的随笔中继续更新CoffeeScript，请持续关注。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/12/20/2827141.html "原文首发")