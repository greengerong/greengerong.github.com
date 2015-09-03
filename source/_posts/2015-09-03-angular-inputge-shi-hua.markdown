---
layout: post
title: "Angular input格式化"
date: 2015-09-03 16:29:35 +0800
comments: true
categories: [angular,javascript]
---

今天在Angular中文群有位同学问到：如何实现对input box的格式化。如下的方式对吗？

	 <input type="text" ng-model="demo.text | uppercase" />


这当然是不对的。在Angular中filter（过滤器）是为了显示数据的格式，它将$scope上的Model数据格式化View显示的数据绑定到DOM之上。它并不会负责ngModel的绑定值的格式化。

在Angular中ngModel作为Angular双向绑定中的重要组成部分，负责View控件交互数据到$scope上Model的同步。当然这里存在一些差异，View上的显示和输入都是字符串类型，而在Model上的数据则是有特定数据类型的，例如常用的Number、Date、Array、Object等。ngModel为了实现数据到Model的类型转换，在ngModelController中提供了两个管道数组$formatters和$parsers，它们分别是将Model的数据转换为View交互控件显示的值和将交互控件得到的View值转换为Model数据。它们都是一个数组对象，在ngModel启动数据转换时，会以UNIX管道式传递执行这一系列的转换。Angular允许我们手动的添加$formatters和$parsers的转换函数（unshift、push）。同时在这里也是做数据验证的最佳时机，能够转换意味应该是合法的数据。

![ngModel](/images/blog_img/ngModelController-生命环.png)

同时，我们也可以利用Angular指令的reuqire来获取到这个ngModelController。如下方式来使用它的$parses和$formaters：

	.directive('textTransform', [function() {

	    return {
	        require: 'ngModel',
	        link: function(scope, element, iAttrs, ngModelCtrl) {
				ngModelCtrl.$parsers.push(function(value) {
					...
				});

				ngModelCtrl.$formatters.push(function(value) {
    				...
  				});
	        }
	    };
    }]);

因此，开篇所描述的输入控件的大写格式化，则可以利用ngModelController实现，在对于View文字大小的格式化，这个特殊的场景下，利用css特性text-transform会更简单。所以实现如下：

	 .directive('textTransform', function() {
		 var transformConfig = {
			 uppercase: function(input){
				 return input.toUpperCase();
			 },
			 capitalize: function(input){
				 return input.replace(
					 /([a-zA-Z])([a-zA-Z]*)/gi,
				     function(matched, $1, $2){
					    return $1.toUpperCase() + $2;
				    });
			 },
			 lowercase: function(input){
				 return input.toLowerCase();
			 }
		 };
	    return {
	        require: 'ngModel',
	        link: function(scope, element, iAttrs, modelCtrl) {
				var transform = transformConfig[iAttrs.textTransform];
				if(transform){
					modelCtrl.$parsers.push(function(input) {
	                	return transform(input || "");
	            	});	

	            	element.css("text-transform", iAttrs.textTransform);
				}
	        }
	    };
	});

则，在HTML就可以如下方式使用指令：

	<input type="text" ng-model="demo.text" text-transform="capitalize" />
	<input type="text" ng-model="demo.text" text-transform="uppercase" />
	<input type="text" ng-model="demo.text" text-transform="lowercase" />

在这里利用了css text-transform特性，对于其它的方式，我们可以使用keydown、keyup、keypress等来实现。如[inputMask](https://github.com/greengerong/green.inputmask4angular)和[ngmodel-format](https://github.com/greengerong/ngmodel-format)。
