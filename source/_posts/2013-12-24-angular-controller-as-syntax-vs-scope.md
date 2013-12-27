---
layout: post
title: "angular controller as syntax vs scope"
description: ""
category: "angularjs"
tags: [angularjs,javascript]
---
今天要和大家分享的是angular从1.2版本开始带来了新语法Controller as。再次之前我们对于angular在view上的绑定都必须使用直接的scope对象，对于controller来说我们也得必须注入$scope这个service。如下：

```js
	angular.module("app",[])
  	.controller("demoController",["$scope",function($scope){
    	$scope.title = "angualr";
 	 }])
```
```html 	
 	<div ng-app="app" ng-controller="demoController">
      	hello : {% raw %}{{title}}{% endraw %} !
    </div>
```

有些人觉得即使这样我们的controller还是不够POJO，以及对于coffescript爱好者不足够友好，所以在angular在1.2给我带来了一个新的语法糖这就是本文将要说的controller as的语法糖，修改上面的demo将会变成：

```js
	angular.module("app",[])
  	.controller("demoController",[function(){
    	this.title = "angualr";
  	}])
 ```
```html 	
  	<div ng-app="app" ng-controller="demoController as demo">
   		 hello : {% raw %}{{demo.title}}{% endraw %} !
  	</div>
```

这里我们可以看见现在controller不再有$scope的注入了，感觉controller就是一个很简单的平面的JavaScript对象了，不存在任何的差别了。再则就是view上多增加了个demoController as demo，给controller起了一个别名，在此后的view模板中靠这个别名来访问数据对象。

或许看到这里你会问为什么需要如此啊，不就是个语法糖而已，先别着急，我们会在后边分析$scope和他的差别。在此之前我们先来看看angular源码的实现这样才会有助于我们的分析：

下面是一段来自angular的code：在1499行开始(行数只能保证在写作的时候有效)

```js

	  if (directive.controllerAs) {
              locals.$scope[directive.controllerAs] = controllerInstance;
       }
       
```

如果你希望看更完全的code请猛击这里[https://github.com/angular/angular.js/blob/c7a1d1ab0b663edffc1ac7b54deea847e372468d/src/ng/compile.js](https://github.com/angular/angular.js/blob/c7a1d1ab0b663edffc1ac7b54deea847e372468d/src/ng/compile.js).

从上面的代码我们能看见的是：angular只是把controller这个对象实例以其as的别名在scope上创建了一个新的对象属性。靠，就这么一行代码搞定！

先别急，既然是语法糖，那么它肯定有他出现的原因，让我们来和直接用$scope对比下：

在此文之前我在angularjs的群中和大家讨论了下我的看法，得到大家不错的反馈，所以有了本文，记录和分享下来。

我规定对于controller as的写法如下：

```js
    angular.module("app",[])
     .controller("demoController",[function(){
            var vm = this;

            vm.title = "angualr";

            return vm;
     }])
```    
     
其优势为：

1. 定义vm这样会让我们更好的避免JavaScript的this的坑。
2. 如果某个版本的angular不再支持controller as,可以轻易的注入$scope,修改为 var vm = $scope;
3. 因为不再注入$scope了，controller更加的POJO，就是一个很普通的JavaScript对象。
4. 也因为没有了$scope，而controller实例将会成为scope上的一个属性，所以在controller中我们再也不能使用$watch,$emit,$on之类的特殊方法，因为这些东西往往不该出现在controller中的，给大家一个警告，更好的控制。但是一旦如果没办法必须用的话，可以在征得项目组一致同意，将此controller退回$scope.
5. 因为controller实例将会只是$scope的一个属性，所以view模板上的所有字段都会在一个引用的属性上，这可以避开JavaScript原型链继承对于值类型的坑。参加[https://github.com/angular/angular.js/wiki/Understanding-Scopes](https://github.com/angular/angular.js/wiki/Understanding-Scopes).
6. controller as 对于 coffescript,liveScript更友好。
7.模板上定义的每个字段方法都会在scope寄存在controller as别名上的引用上，所以在controller继承中，不会在出现命名冲突的问题。

注释:对于route，也有个controllerAs的属性可以设置，下面代码来之angular doc文档：
	
```js
	 	angular.module('ngViewExample', ['ngRoute', 'ngAnimate'],
     	 function($routeProvider, $locationProvider) {
        $routeProvider.when('/Book/:bookId', {
          templateUrl: 'book.html',
          controller: BookCntl,
          controllerAs: 'book'
        });
        $routeProvider.when('/Book/:bookId/ch/:chapterId', {
          templateUrl: 'chapter.html',
          controller: ChapterCntl,
          controllerAs: 'chapter'
        });

        // configure html5 to get links working on jsfiddle
       		 $locationProvider.html5Mode(true);
   		 });
    
```
今天就到这里，谢谢。 




