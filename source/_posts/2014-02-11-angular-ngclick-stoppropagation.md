---
layout: post
title: "angular ngClick 阻止冒泡和默认行为"
date: 2014-02-11 22:27:29 +0800
comments: true
category: "angularjs"
tags: [angular,javascript] 
---
这其实是一个很简单的问题，如果你认真查看过Angular官方的API文档，本来不想记录的。但是这个问题不止一次的被人问起，所以今天在记录在这里。

在Angular中已经对一些ng事件如ngClick,ngBlur,ngCopy,ngCut,ngDblclick...中加入了一个变量叫做$event.

如ngClick在官方文档是这么描述的：
    
    Expression to evaluate upon click. (Event object is available as $event)

在查看Angular代码[ngEventDirs.js](https://github.com/angular/angular.js/blob/a68624444afcb9e3796b1a751cf3817cafd20240/src/ng/directive/ngEventDirs.js):

        var ngEventDirectives = {};
        forEach(
          'click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave keydown keyup keypress submit focus blur copy cut paste'.split(' '),
          function(name) {
            var directiveName = directiveNormalize('ng-' + name);
            ngEventDirectives[directiveName] = ['$parse', function($parse) {
              return {
                compile: function($element, attr) {
                  var fn = $parse(attr[directiveName]);
                  return function(scope, element, attr) {
                    element.on(lowercase(name), function(event) {
                      scope.$apply(function() {
                        fn(scope, {$event:event});
                      });
                    });
                  };
                }
              };
            }];
          }
        );

在上边代码我们可以得到两个信息：

1. Angular支持的event： click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave keydown keyup keypress submit focus blur copy cut paste
2. Angular在执行事件函数时候传入了一个名叫$event的常量，该常量即代表当前event对象，如果你在Angular之前引入了jQuery那么这就是jQuery的event.

所以我们可以利用event的stopPropagation来阻止事件的冒泡：如下代码：[jsbin](http://jsbin.com/delow/3/watch?html,js,output)

html 代码
        <!DOCTYPE html>
        <html id="ng-app" ng-app="app">
        <head>
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.1.5/angular.min.js"></script>
          <meta charset="utf-8">
          <title>JS Bin</title>
        </head>
        <body ng-controller="demo as d">
           <div ng-click="d.click('parent',$event)">
             given some text for click
             <hr>
             <input type="checkbox" ng-model="d.stopPropagation" />Stop Propagation ?
             <hr>
             <button type="button" ng-click="d.click('button',$event)">button</button>
             
           </div>
        </body>
        </html>             

js 代码
    
    angular.module("app",[])
    .controller("demo",[function(){
      var vm = this;
      
      vm.click = function(name,$event){
        console.log(name +" -----called");
        if(vm.stopPropagation){
          $event.stopPropagation();
        }
      };
      
      return vm;
    }]);

可以在jsbin](http://jsbin.com/delow/3/watch?html,js,output)查看效果。

首先打开你的控制台，然在没选中Stop Propagation的情况下点击button你将会看见两条log记录，相反选中后则只会出现button的log信息。

希望大家已经明白了，不要再问这类问题了。