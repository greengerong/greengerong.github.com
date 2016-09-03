---
layout: post
title: "解决ng界面长表达式(ui-set)"
date: 2014-09-29 16:52:55 +0800
comments: true
categories: [angular]
---
本文来自网友sun shine的问题，问题如下：

		您好, 我想求教一个问题.
		在$scope中我的对象名字写的特别深, 在 html中我又多次用到了同一个对象, 对不对在 html中让它绑定到一个临时变量呢?
		比如:
		$scope.this.is.a.very.deep.obj = {
		'name': 'xxx',
		'state': 'active'};

		在 模板中,

		{% raw %}{{this.is.a.very.deep.obj.name}}{% endraw %}
		{% raw %}{{this.is.a.very.deep.obj.state}}{% endraw %}
		类似于这种, 我能否把 this.is.a.very.deep.obj 预先赋给一个临时的变量, 然后在 两个 span中只需 o.name, o.state 就行了呢? 我觉得这样解析起来是不是快一点.

		但是我试了, 并没有成功. 求指点.
		先谢了.


在这里首先需要说明的是ng界面的所有引用都需要在$scope这个viewmodel(ui和view的胶水层)，所以如果我们希望能够把表达式变得更可读，更友好，那么我们就必须在$scope上创建这个变量。

再则对于ng其使用使用的一堆的$watch，实现脏检查，如果你理解这些了，那么我们就可以很容易的实现一套如spring的

	<c:set var="xxx" expression="xxx" />

的tag.

对于实现这类tag，我们最好的方式则是利用ng的directive来实现，代码如下：

			angular.module("greengerong.ui.tag", [])
			  .directive("uiSet", [
			    function() {
			      return {
			        restrict: "EA",
			        link: function(scope, elm, iAttrs) {
			          scope.$watch(iAttrs.expression, function(val) {
			            scope[iAttrs.
			              var] = val;
			            var apply = !scope.$$phase ? scope.$apply : angular.noop;
			            apply();
			          });
			        }
			      };
			    }
			  ]);

demo效果请移步[jsbin demo](http://jsbin.com/neqow/3/edit);

