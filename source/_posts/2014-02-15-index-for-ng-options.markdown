---
layout: post
title: 为Angularjs ngOptions加上index解决方案
date: 2014-02-15 21:43:06 +0800
comments: true
categories: 
---
今天在Angularjs交流群中有位童学问道如何为Angular select的ngOptions像Angularjs的ngRepeat一样加上一个索引$index.

其实对于这个问题来说Angular本身并未提供$index之类的变量供使用。但是也不是说对于这个问题我们就没有解决方案。

把这个问题换成角度来看,我们所需要的就是js数组的下标，所以我们如果我们能够在对象上加入下标，使用表达式作为option的label就能解决了。

但是第一印象让我想起的是js数组本来就是一个key/value的对象，只是key为数组下标而已，所以有了如下之设计：

html:

      <pre>{{ a | json }}</pre>
      
      <select  ng-model="a" ng-options="value.field as getDesc1(key,value) for (key,value) in t"></select>

  js:

    $scope.getDesc1 = function(key, value) {
        return (parseInt(key, 10) + 1) + "->" + value.field;
    };

可是不幸的是如果对于JavaScript你若将他作为key/value对象那么key将是无序的所以，出现了无序的下标如下：

    <select ng-model="a" ng-options="l.field as getDesc1(key,value) for (key,value) in t " class="ng-valid ng-dirty">
      <option value="0"  >1-&gt;jw_companyTalent</option>
      <option value="1"  >2-&gt;jw_reportgroup</option>
      <option value="10" >11-&gt;jw_ads</option>
      <option value="11" >12-&gt;jw_jobcomment</option>
      <option value="12" >13-&gt;jw_companyInfo</option>
      ....
    </select>

所以这样是无法解决的。还好博主还有一招，ngOptions支持Angularjs的filter，所以我们可以对数据源对象上加上一个order字段标示下标作为序号。并且你可以在一个2年前的Angular的issue中看到Angular已经fix issue，option会对数组进行按下标顺序生成。

html:

    <pre>{{ b | json }}</pre>

    <select  ng-model="b" ng-options="l.field as getDesc(l) for l in t | index "></select>

js:

        var app = angular.module('plunker', []);

        app.controller('MainCtrl', function($scope) {
          $scope.t = [{
            "field": "jw_companyTalent"
          }, {
            "field": "jw_reportgroup"
          }];
          $scope.getDesc = function(l) {
            return l.order + "->" + l.field;
          };
        }).filter("index", [
          function() {
            return function(array) {
              return (array || []).map(function(item, index) {
                item.order = index + 1;
                return item;
              });
            };
          }
        ]);

这下option是按照有序的生成，最后我们终于能完美解决了,所以本文也将收尾。在最后在附上可运行的demo[plnkr ngOptions index](http://plnkr.co/edit/tRxzOT?p=preview);


