---
layout: post
title: "Zone.js - 暴力之美"
date: 2016-01-30 21:27:00 +0800
comments: true
categories: [angular2, javascript]
---

在ng2的开发过程中，Angular团队为我们带来了一个新的库 - zone.js。zone.js的设计灵感来源于Dart语言，它描述JavaScript执行过程的上下文，可以在异步任务之间进行持久性传递，它类似于Java中的TLS（[thread-local storage: 线程本地存储](http://en.wikipedia.org/wiki/Thread-local_storage)）技术，zone.js则是将TLS引入到JavaScript语言中的实现框架。

那么zone.js能为我们解决什么问题呢？在回答这个问题之前，博主更希望回顾下在JavaScript开发中，我们究竟遇见了什么难题？

#### 问题引入

我们先来看一段常规的同步JavaScript代码：

	var foo = function(){ ... },
		bar = function(){ ... },
		baz = function(){ ... };

	foo();
	bar();
	baz();

这段代码并没有什么特殊之处，它的执行顺序也并无什么特殊之处，完全在我们的预知之内：foo -> bar -> baz。对它做性能监测也很容易，我们只需要在执行上下文前后记录执行时间即可。

	var start, 
		timer = performance ? performance.now.bind(performance) : Date.now.bind(Date);
	
	start = timer();

	foo(); 
	bar(); 
	baz(); 
	
	console.log(Math.floor((timer() - start) * 100) / 100 + 'ms');

但在JavaScript的世界并不全是这么简单，众所周知的JavaScript单线程执行的。因此为了不阻塞UI界面的用户体验，在JavaScript执行的很多耗时操作都被封装为了异步操作，如：setTimeout、XMLHttpRequest、DOM事件等。由于浏览器的寄宿限制，JavaScript中异步操作是与生俱来的特性，被深深的印在了骨髓之中。这也是Ryan Dahl博士选择JavaScript开发Node.js平台的原因之一。关于JavaScript单线程执行可以参考博主的另一篇博文：[JavaScript单线程和浏览器事件循环简述](http://greengerong.com/blog/2015/10/27/javascript-single-thread-and-browser-event-loop/)。

那么对于下面这段异步代码，我们又如何做性能监测呢？

	var foo = function(){ setTimeout(..., 2000); },
		bar = function(){ $.get(...).success(...); },
		baz = function(){ ... };

	foo();
	bar();
	baz();


在这段代码中，引入了setTimeout和AJAX异步调用。其中AJAX回调和setTimeout回调时间顺序很难确定，因此给这段代码引入性能检测代码并不像上面的顺序执行代码一样那么简单了。如果我们需要强行加入性能的检测，则会在setTimeout和$.get回调中插入相关的hook代码并并记录执行时间，这样我们的业务代码也会变得非常混乱，就像一团“意大利拉面”一样（What the fuck！）。

#### zone.js简介

在本文开篇提到zone.js为JavaScript提供了执行上下文，可以在异步任务之间进行持久性传递。该是zone.js上场的时候了。zone.js采用猴子补丁（Monkey-patched）的暴力方式将JavaScript中的异步任务都包裹了一层，使得这些异步任务都将运行在zone的上下文中。每一个异步的任务在zone.js都被当做为一个Task，并在Task的基础上zone.js为开发者提供了执行前后的钩子函数（hook）。这些钩子函数包括：

* 	onZoneCreated：产生一个新的zone对象时的钩子函数。zone.fork也会产生一个继承至基类zone的新zone，形成一个独立的zone上下文；
*	beforeTask：zone Task执行前的钩子函数；
*	afterTask：zone Task执行完成后的钩子函数；
*	onError：zone运行Task时候的异常钩子函数；

并且zone.js对JavaScript中的大多数异步事件都做了包裹封装，它们包括：

*	zone.alert;
*	zone.prompt;
*	zone.requestAnimationFrame、zone.webkitRequestAnimationFrame、zone.mozRequestAnimationFrame;
*	zone.addEventListener;
*	zone.addEventListener、zone.removeEventListener;
*	zone.setTimeout、zone.clearTimeout、zone.setImmediate;
*	zone.setInterval、zone.clearInterval

以及对promise、geolocation定位信息、websocket等也进行了包裹封装，你可以在这里找到它们[https://github.com/angular/zone.js/tree/master/lib/patch](https://github.com/angular/zone.js/tree/master/lib/patch)。


下面我们先来看一个简单的zone.js示例：

	var log = function(phase){
		return function(){
			console.log("I am in zone.js " + phase + "!");
		};
	};

	zone.fork({
		onZoneCreated: log("onZoneCreated"),
		beforeTask: log("beforeTask"),
		afterTask: log("afterTask"),
	}).run(function(){
		var methodLog = function(func){
			return function(){
				console.log("I am from " + func + " function!");
			};
		},
		foo = methodLog("foo"),
		bar = methodLog("bar"),
		baz = function(){
			setTimeout(methodLog('baz in setTimeout'), 0);
		};
		
		foo();
		baz();
		bar();
	});

执行这段示例代码的输出是：

	I am in zone.js beforeTask!
	I am from foo function!
	I am from bar function!
	I am in zone.js afterTask!

	I am in zone.js onZoneCreated!
	I am in zone.js beforeTask!
	I am from baz in setTimeout function!
	I am in zone.js afterTask!

从上面的输出结果，我们能够看出在zone.js中将run方法块分为了两个Task，它们分别是方法体运行时的Task和异步setTimeout的Task。并且我们能够在这些Task的创建，执行前后拦截并做一些有意义的事情。

在zone.js中fork方法会产生一个继承至zone的子类，并在fork函数中可以配置特定的钩子方法，形成独立的zone上下文。而run方法则是启动执行业务代码的对外接口。

同时zone也支持父子继承，以及它也定义了一套DSL语法，支持$、+、-的前缀。

*	$会传递父类zone的钩子函数，便于对zone钩子函数执行的控制；
*	-代表在父zone的钩子函数之前运行本钩子函数；
*	+则与之相反，代表在父zone的钩子函数之后运行本钩子函数

更多的语法使用，请参考zone.js github首页文档[https://github.com/angular/zone.js](https://github.com/angular/zone.js)。

#### 引入zone.js

有了上面的这些关于zone.js的基础知识，在本文开始的遗留问题我们就可以迎刃而解了。下面这段代码是来自zone.js项目的示例代码：[https://github.com/angular/zone.js/blob/master/example/profiling.html](https://github.com/angular/zone.js/blob/master/example/profiling.html)

	var profilingZone = (function () {
	    var time = 0,
	        timer = performance ?
	                    performance.now.bind(performance) :
	                    Date.now.bind(Date);
	    return {
	      beforeTask: function () {
	        this.start = timer();
	      },
	      afterTask: function () {
	        time += timer() - this.start;
	      },
	      time: function () {
	        return Math.floor(time*100) / 100 + 'ms';
	      },
	      reset: function () {
	        time = 0;
	      }
	    };
	  }());

	  zone.fork(profilingZone).run(function(){

	  	 //业务逻辑代码

	  });

这里在beforeTask中启动了时间计算，并在afterTask中计算出当前累积的花费的时间。因此我们在业务代码的逻辑中就可以随时利用zone.time()来获取当前耗时了。

#### zone.js的实现

了解了zone.js的时候之后，或许你会像我一样感觉很神奇，它是如何实现的呢？

下面是zone.js中browser.ts的代码片段（[https://github.com/angular/zone.js/blob/master/lib/patch/browser.ts](https://github.com/angular/zone.js/blob/master/lib/patch/browser.ts)）：

	export function apply() {
	  fnPatch.patchSetClearFunction(global, global.Zone, [
	    ['setTimeout', 'clearTimeout', false, false],
	    ['setInterval', 'clearInterval', true, false],
	    ['setImmediate', 'clearImmediate', false, false],
	    ['requestAnimationFrame', 'cancelAnimationFrame', false, true],
	    ['mozRequestAnimationFrame', 'mozCancelAnimationFrame', false, true],
	    ['webkitRequestAnimationFrame', 'webkitCancelAnimationFrame', false, true]
	  ]);

	  fnPatch.patchFunction(global, [
	    'alert',
	    'prompt'
	  ]);

	  eventTargetPatch.apply();

	  propertyDescriptorPatch.apply();

	  promisePatch.apply();

	  mutationObserverPatch.patchClass('MutationObserver');
	  mutationObserverPatch.patchClass('WebKitMutationObserver');

	  definePropertyPatch.apply();

	  registerElementPatch.apply();

	  geolocationPatch.apply();

	  fileReaderPatch.apply();
	}

从这里我们能看到，zone.js对浏览器中的setTimeout、setInterval、setImmediate、以及事件、promise、地理信息geolocation都做了特殊处理。那么这些处理是怎么处理的呢？下面是关于fnPatch.patchSetClearFunction的实现代码，来自zone.js中functions.ts（[https://github.com/angular/zone.js/blob/master/lib/patch/functions.ts](https://github.com/angular/zone.js/blob/master/lib/patch/functions.ts)）的代码片段：

	export function patchSetClearFunction(window, Zone, fnNames) {
	  function patchMacroTaskMethod(setName, clearName, repeating, isRaf) {
	    //浏览器原生方法留存
	    var setNative = window[setName];
    	var clearNative = window[clearName];
    	var ids = {};

	    if (setNative) {
	      var wtfSetEventFn = wtf.createEvent('Zone#' + setName + '(uint32 zone, uint32 id, uint32 delay)');
	      var wtfClearEventFn = wtf.createEvent('Zone#' + clearName + '(uint32 zone, uint32 id)');
	      var wtfCallbackFn = wtf.createScope('Zone#cb:' + setName + '(uint32 zone, uint32 id, uint32 delay)');

	      // 对浏览器原生方法的包裹封装
	      window[setName] = function () {
	        return global.zone[setName].apply(global.zone, arguments);
	      };

	      // 对浏览器原生方法的包裹封装
	      window[clearName] = function () {
	        return global.zone[clearName].apply(global.zone, arguments);
	      };


	      // 创建自己包裹方法，由上面的wind[setName]转移到这里执行.
	      Zone.prototype[setName] = function (fn, delay) {
	        
	        var callbackFn = fn;
	        if (typeof callbackFn !== 'function') {
	          // force the error by calling the method with wrong args
	          setNative.apply(window, arguments);
	        }
	        var zone = this;
	        var setId = null;
	        // wrap the callback function into the zone.
	        arguments[0] = function() {
	          var callbackZone = zone.isRootZone() || isRaf ? zone : zone.fork();
	          var callbackThis = this;
	          var callbackArgs = arguments;
	          return wtf.leaveScope(
	              wtfCallbackFn(callbackZone.$id, setId, delay),
	              callbackZone.run(function() {
	                if (!repeating) {
	                  delete ids[setId];
	                  callbackZone.removeTask(callbackFn);
	                }
	                return callbackFn.apply(callbackThis, callbackArgs);
	              })
	          );
	        };
	        if (repeating) {
	          zone.addRepeatingTask(callbackFn);
	        } else {
	          zone.addTask(callbackFn);
	        }
	        setId = setNative.apply(window, arguments);
	        ids[setId] = callbackFn;
	        wtfSetEventFn(zone.$id, setId, delay);
	        return setId;
	      };
	      ......
	     
	    }
	  }
	  fnNames.forEach(function(args) {
	    patchMacroTaskMethod.apply(null, args);
	  });
	};

在上面的代码中，首先会将浏览器的原生方法保存在setNative中以便将会重用。紧接着zone.js就开始了它的暴力行为，覆盖window[setName]和window[clearName]然后将对setName的调用转到自身的zone[setName]的调用，zone.js就是如此暴力的对浏览器原生对象实现了拦截转移。然后它会在Task执行的前后调用自身的addRepeatingTask、addTask以及wtf事件来应用注册上的所有钩子函数。

到这里相信作为读者的你已经明白了zone.js的实现机制了，是不是和笔者一样有种“简单粗暴”的感觉？但是它真的很强大，为我们实现了对异步Task的跟踪、分析等。

#### zone.js应用场景

zone.js能实现异步Task跟踪，分析，错误记录、开发调试跟踪等，这些都是zone.js场景的应用场景。你也可以在[https://github.com/angular/zone.js/tree/master/example](https://github.com/angular/zone.js/tree/master/example)看见更多的示例代码，以及Brian在ng-conf 2014关于zone.js的演讲视频: [https://www.youtube.com/watch?v=3IqtmUscE_U](https://www.youtube.com/watch?v=3IqtmUscE_U).

当然对于一些特定的业务分析zone.js也有它很好的运用场景。如果你使用过Angular1的开发，那么也许你还能记忆犹新的想起：使用第三方事件或者ajax却忘记$scope.$apply的场景吧。在Angular1中如果在非Angular的上下文改变数据Model，Angular是无法预知的，因此也不会触发界面的更新。所以我们不得不显示的调用$scope.$apply或者$timeout来触发界面的更新。Angular框架为了更多的获知变化的事件，不得不为封装了一整套框架内置的服务和指令，如ngClick、ngChange、$http,$timeout等，这也增加了Angular1的学习成本。

也是为了解决Angular1的这一些列问题，Angular2团队引入了zone.js，放弃自定义这类服务和指令，相反而是拥抱浏览器的原生对象和方法。所以在Angular2中可以使用浏览器的任何事件了，只需要括号模板语法的标识：(eventName),等价于on-eventName；也可以直接使用浏览器的原生对象了，如setTimeout，addEventListener、promise、fetch等。

当然，zone.js也能应用于Angular1的项目之中。示例代码如下（[http://jsbin.com/kenilivuvi/edit?html,js,output](http://jsbin.com/kenilivuvi/edit?html,js,output)）：

	angular.module("com.ngbook.demo", [])
	    .controller("DemoController", ['$scope', function($scope){
	     
			zone.fork({
				afterTask: function(){
					var phase = $scope.$root.$$phase;
					if(['$apply', '$digest'].indexOf(phase) === -1) {
	    				$scope.$apply();
	   				 }
	  			}
			}).run(function(){
				
				setTimeout(function(){
					$scope.fromZone = "I am from zone with setTimeout!";
				}, 2000);
			});
			
		}]);


在示例代码中，在每次Task的完成后都会尝试$scope.$apply，强制将Model数据的改变更新到UI界面。对于在Angular1中使用zone.js更多的地方应该是在Directive中，同时也可以将zone的创建过程封装为服务（工厂方法，每次返回一个全新的zone对象）。在Angular2中也有同样zone的封装，它被称为ngZone（[https://github.com/angular/angular/blob/master/modules/angular2/src/core/zone/ng_zone.ts](https://github.com/angular/angular/blob/master/modules/angular2/src/core/zone/ng_zone.ts)）。
 