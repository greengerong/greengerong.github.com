---
layout: post
title: "angularjs 过滤器filter"
description: "angularjs 过滤器filter"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在前面介绍angularjs已经很多了，中途由于工作和一切生活琐事，暂停了很久。今天在这里将继续angularjs讲解，这节我们来看看angularjs的过滤去filter。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在我们开发中经常需要在页面显示给用户的信息需要一定处理格式化，才能显示给用户。比如时间本地化，或者yyyy-MM-dd HH:mm:ss格式，数字精度格式化，本地化，人名格式化等等。在angularjs中为我们提供了叫filter的指令，让我们能够很轻易就能做到着一些列的功能，angularjs内部为我们提供了number等很多内置的filter。并且我们能够很轻易的自定义自己的领域filter。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如下实例：

html:

	<div ng-app="app" ng-controller="test">
	num:<input ng-model="num" />
		<br/>
	{{num | number}}
	<br/>
	{{num | number:2}}
	<br/>
	first name:<input ng-model="person.first"/>
	<br/>
	last name:<input ng-model="person.last"/>
	<br/>
	name: {{person | fullname}}
  	  <br/>
	name: {{person | fullname:"- -"}}
   	    <br/>
	name: {{person | fullname:" " | uppercase }}
	</div>

js:

	function test($scope) {

	}

	angular.module("app", []).controller("test", test).

	filter("fullname", function() {

    	var filterfun = function(person, sep) {

       		 sep = sep || " ";

        	person = person || {};

        	person.first = person.first || "";

        	person.last = person.last || "";

        	return person.first + sep + person.last;

   	 };

    	return filterfun;

	});

jsfiddle效果：[http://jsfiddle.net/whitewolf/uCPPK/9/](http://jsfiddle.net/whitewolf/uCPPK/9/)

<iframe height="300" src="http://jsfiddle.net/whitewolf/uCPPK/12/embedded/" frameborder="0" width="100%" stye="border:none;overflow:none;"></iframe>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在实例中首先演示了angularjs自带的number的filter使用。再同样为我们样式了如何去创建一个angularjs的filter。其实现很简单.angularjs使得扩展一切变得自然

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 最后说明：angularjs filters支持链式写法，如何powershell或者其他操作系统外壳语言一样的管道式模型，形如 value | filter1 | filter2。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/10/31/2748920.html "原文首发")