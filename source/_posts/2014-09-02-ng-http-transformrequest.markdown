---
layout: post
title: "ng http request/response格式转换"
date: 2014-09-02 22:59:05 +0800
comments: true
categories: [angular,form,transformRequest]
---
angular作为Single Page Application推荐的交互方式当然是基于json的ajax调用。但今天要说的是当你不幸工作在一个遗留或者不可控制的服务上，而这服务是基于非json提交方式(或许是常规表单(form)提交，或者其他自定义数据格式)，那么我们只能改变ng内部$http默认request/response格式转化方式。

所幸的是ng $http给我们提供了多种可用方式转化数据格式(下面demo将以form提交方式为例):

***对于部分单独的http request设置：

对于http ajax方式最后一个参数都是关于http的配置信息，其中包括一项transformRequest，我们可以利用transformRequest在ajax发送数据之前改变数据的格式，例如下边的demo:

	$http.post("/url", {
          id: 1,
          name: "greengerong"
        }, {
          transformRequest: function(request) {
            return $.param(request);
      	}
    });

这里利用jQuery的$.param进行表单提交方式的格式转化，所以我们能够看见的request body 为：

	id=1&name=greengerong

online [demo](http://plnkr.co/edit/tpl:FrTqqTNoY8BEfHs9bB0f);

***对于整个app的http request设置：

如果我们需要对整个http的数据转化格式进行设置，那么可以选用在config阶段对$httpProvider默认行为进行设置：

	angular.module("app", [])
	.config(["$httpProvider", function($httpProvider) {
	      $httpProvider.defaults.transformRequest = [
	        function(request) {
	          return $.param(request);
	        }
	      ];
    	}
  	]);

这样我们就可以轻易的转化为form提交方式。

同样$http也为我们提供了transformResponse方式，我们也可以创建自己的response转化，比如json之前加入自定义前缀防止json array攻击等等。

