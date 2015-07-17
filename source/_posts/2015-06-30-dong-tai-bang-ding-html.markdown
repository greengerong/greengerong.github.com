---
layout: post
title: "动态绑定HTML"
date: 2015-06-30 06:38:36 +0800
comments: true
categories: [angular,JavaScript]
---
在Web前端开发中，我们经常会遇见需要动态的将一些来自后端或者是动态拼接的HTML字符串绑定到页面DOM显示，特别是在内容管理系统（CMS：是Content Management System的缩写），这样的需求，更是遍地皆是。

对于对angular的读者肯定首先会想到ngBindHtml，对,angular为我们提供了这个指令来动态绑定HTML，它会将计算出来的表达式结果用innerHTML绑定到DOM。但是，问题并不是这么简单。在Web安全中XSS（Cross-site scripting，脚本注入攻击），它是在Web应用程序中很典型的计算机安全漏洞。XSS攻击指的是通过对网页注入可执行客户端代码且成功地被浏览器执行，来达到攻击的目的，形成了一次有效XSS攻击，一旦攻击成功，它可能会获取到用户的一些敏感信息、改变用户的体验、诱导用户等非法行为，有时XSS攻击还会合其他攻击方式同时实施比如SQL注入攻击服务器和数据库、Click劫持、相对链接劫持等实施钓鱼，它带来的危害是巨大的，也是web安全的头号大敌。更多的Web安全问题，请参考wiki https://en.wikipedia.org/wiki/Cross-site_scripting。

在angular中默认是不相信添加的HTML内容，对于添加的HTML内容，首先必须利用$sce.trustAsHtml，告诉angular这是可信的HTML内容。否则你将会得到$sce:unsafe的异常错误。

	Error: [$sce:unsafe] Attempting to use an unsafe value in a safe context.


下面是一个绑定简单的angular链接的demo：

HTML：

	<div ng-controller="DemoCtrl as demo">
	    <div ng-bind-html="demo.html"></div>
	</div>

JavaScript：

	angular.module("com.ngbook.demo", [])
	    .controller("DemoCtrl", ["$sce", function($sce) {
	        var vm = this;

	        var html = '<p>hello <a href="https://angular.io/">angular</a></p>';
	        vm.html = $sce.trustAsHtml(html);

	        return vm;
	    }]);

对于简单的静态HTML，这个问题就解决了。但对于复杂的HTML，这里的复杂是指带有angular表达式、指令的HTML模板，对于它们来说，我们不仅希望绑定大DOM显示，同时还希望得到angular强大的双向绑定机制。ngBindHhtml并不会和$scope关联双向绑定，如果在HTML中存在ngClick、ngHref、ngSHow、ngHide等angular指令，它们并不会被compile，点击这些按钮，也不会发生任何反应，绑定的表达式也不会在更新。例如尝试将上次的链接变为：ng-href="demo.link"，链接并不会被解析，在DOM看见的仍然会是原样的HTML字符串。

在angular中的所有指令要生效，都需要经过compile，在compile中包含了pre-link和post-link，连接上特定行为，才能工作。大部分情况下compile，是会在angular启动时，自动compile的。但如果是对于动态添加的模板，则需要手动的compile。angular中为我们提供了$compile服务来实现这一功能。下面是一个比较通用的compile例子：

HTML：

	<body ng-controller="DemoCtrl as demo">
	    <dy-compile html=" {% raw %} {{demo.html}} {% endraw %} ">
	    </dy-compile>
	    <button ng-click="demo.change();">change</button>
	</body>

JavaScript：

	angular.module("com.ngbook.demo", [])
	    .directive("dyCompile", ["$compile", function($compile) {
	        return {
	            replace: true,
	            restrict: 'EA',
	            link: function(scope, elm, iAttrs) {
	                var DUMMY_SCOPE = {
	                        $destroy: angular.noop
	                    },
	                    root = elm,
	                    childScope,
	                    destroyChildScope = function() {
	                        (childScope || DUMMY_SCOPE).$destroy();
	                    };

	                iAttrs.$observe("html", function(html) {
	                    if (html) {
	                        destroyChildScope();
	                        childScope = scope.$new(false);
	                        var content = $compile(html)(childScope);
	                        root.replaceWith(content);
	                        root = content;
	                    }

	                    scope.$on("$destroy", destroyChildScope);
	                });
	            }
	        };
	    }])
	    .controller("DemoCtrl", [function() {
	        var vm = this;

	        vm.html = '<h2>hello : <a ng-href=" {% raw %} {{demo.link}} {% endraw %}  ">angular</a></h2>';

	        vm.link = 'https://angular.io/';
	        var i = 0;
	        vm.change = function() {
	            vm.html = '<h3>change after : <a ng-href=" {% raw %} {{demo.link}} {% endraw %} ">' + (++i) + '</a></h3>';
	        };
	    }]);

这里创建了一个叫dy-compile的指令，它首先会监听绑定属性html值的变化，当html内容存在的时候，它会尝试首先创个一个子scope，然后利用$compile服务来动态连接传入的html，并替换掉当前DOM节点；这里创建子scope的原因，是方便在每次销毁DOM的时，也能容易的销毁掉scope，去掉HTML compile带来的watchers函数，并在最后的父scope销毁的时候，也会尝试销毁该scope。

因为有了上边的compile的编译和连接，则ngHref指令就可以生效了。这里只是尝试给出动态compile angular模块的例子，具体的实现方式，请参照你的业务来声明特定的directive。
