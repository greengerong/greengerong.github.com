---
layout: post
title: "ngCloak 实现 angular 初始化闪烁最佳实践"
category: "angularjs"
tags: [angular,javascript] 
---

在做angular的SPA开发时，我们经常会遇见在如Chrome这类能够快速解析的浏览器上出现表达式({% raw %} {{ express }} {% endraw %} ),或者是模块(div)的闪烁。对于这个问题由于JavaScript去操作DOM，都会等待DOM加载完成（DOM ready）。对于angular会在DOM ready完会才回去解析html view Template，所以对于Chrome这类快速的浏览器你会看见有闪烁的情况出现。而对于IE7，8这类解析稍慢的浏览器大部分情况下是不会出现这个问题的。

在angular中为我们提供了ng-cloak来实现纺织闪烁的方案，我们只需要在需要的地方加上ng-cloak。同时对于bing文字({% raw %}{{ express }} {% endraw %})我们也可以改为ng-bind来实现避免。

	 <div id="template1" ng-cloak>{{ 'hello' }}</div>
     <div id="template2" ng-cloak class="ng-cloak">{% raw %} {{ 'hello IE7' }} {% endraw %} </div>
     <div id="template2" ng-bing="'hello IE7'"></div>

angular将ng-cloak实现为一个directive，并会在初始化的时候在DOM的heade增加一行css代码，如下：

	<style type="text/css">@charset "UTF-8";[ng\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak,.ng-hide{display:none !important;}ng\:form{display:block;}.ng-animate-start{clip:rect(0,auto,auto,0);-ms-zoom:1.0001;}.ng-animate-active{clip:rect(-1px,auto,auto,0);-ms-zoom:1;}
	</style>
	
从上面我们可以看见angular将带有ng-clock的的元素设置为display:none，隐藏掉，在等到angular解析到带有ng-clock的节点时候，会把attribute和class同时remove掉，这样就可以实现防止节点的闪烁。

	var ngCloakDirective = ngDirective({
          compile: function(element, attr) {
            attr.$set('ngCloak', undefined);
            element.removeClass('ng-cloak');
          }
    });
    
在angular-bootstrap.js中会看见这样的代码去增加前面所说的css：

	  document.write('<link rel="stylesheet" type="text/css" href="' + serverPath + '../css/angular.css"/>');
	  
好像闪烁的问题好像已经能够被我解决了，恩是否是这样的，理论也改如此，但是现实是残酷的，我们的感性认识经常会被现实一记重重的耳光，我们才能很更深入全面的思考，如果浏览器的速度比angular在head中加入css的速度还快呢？我在给公司的一个项目组解决这个闪烁的问题的时候就遇见了这个问题。怎么办呢？那我们只能使出我们必杀技，自己把css加入我们的css文件引入heade，启动加载，ok这样就可以完美解决了。(如果你也遇见了加了ng-cloak还不起作用的话，那么试试直接引入css文件吧)

到这里关于ng-cloak的原理和解决方案已经完成，欢迎继续关注angular的后续经验篇分享。


