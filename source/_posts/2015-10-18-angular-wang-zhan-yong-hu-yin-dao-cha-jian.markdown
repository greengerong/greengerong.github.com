---
layout: post
title: "自定义Angular插件 - 网站用户引导"
date: 2015-10-18 19:47:51 +0800
comments: true
categories: [angular, javascript]
---

最近由于项目进行了较大的改版，为了让用户能够适应这次新的改版，因此在系统中引入了“用户引导”功能，对于初次进入系统的用户一些简单的使用培训training。对于大多数网站来说，这是一个很常见的功能。所以在开发这个任务之前，博主尝试将其抽象化，独立于现有系统的业务逻辑，将其封装为一个通用的插件，使得代码更容易扩展和维护。

无图无真相，先上图：

![training demo](/images/blog_img/training-demo.png)

关于这款trainning插件的使用很简单，它采用了类似Angular路由一样的配置，只需要简单的配置其每一步training信息。

* title：step的标题信息；
* template/templateUrl: step的内容模板信息。这类可以配置html元素，或者是模板的url地址，同时templateUrl也支持Angular route一样的function语法。
* controller: step的控制器配置；可注入当前step信息currentStep，所有step的配置trainnings，当前step的配置信息currentTrainning，以及下一步的操作回调trainningInstance：nextStep'：进入下一个step，cancel'：为取消显示用用引导；
* controllerAs: controller的别名；
* resolve：在controller初始化前的数据配置，同Angular路由中的resolve；
* locals：本地变量，和resolve相似，可以传递到controller中。区别之处在于它不支持function调用，对于常量书写会比resolve更方便；
* placement: step容器上三角箭头的显示方位，
* position: step容器的具体显示位置，这是一个绝对坐标；可以传递`{left: 100, top: 100}`的绝对坐标，也可以是`#stepPanelHost`配置相对于此元素的placement位置。同时它也支持自定义function和注入Angular的其他组件语法。默认会引入所有step配置trainnings变量,当前步骤step，当前step的配置信息currentTrainning，以及step容器节点stepPanel；
* backdrop：是否需要显示遮罩层，默认显示，除非显示声明为false配置，则不会显示遮罩层；
* stepClass：每一个step容器的样式信息；
* backdropClass： 每一个遮罩层的样式信息。

了解了这些配置后，并根据特定需求定制化整个用户引导的配置信息后，我们就可以使用trainningService的trainning方法来在特定实际启动用户引导，传入参数为每一步step的配置信息。并可以注册其done或者cancel事件：

	trainningService.trainning(trainningCourses.courses)
        .done(function() {
            vm.isDone = true;
        });


下面是一个演示的配置信息：

		.constant('trainningCourses', {
			        courses: [{
			            title: 'Step 1:',
			            templateUrl: 'trainning-content.html',
			            controller: 'StepPanelController',
			            controllerAs: 'stepPanel',
			            placement: 'left',
			            position: '#blogControl'
			        }, {
			            title: 'Step 2:',
			            templateUrl: 'trainning-content.html',
			            controller: 'StepPanelController',
			            controllerAs: 'stepPanel',
			            placement: 'right',
			            backdrop: false,
			            position: '#submitBlog'
			        }, {
			            title: 'Step 3:',
			            templateUrl: 'trainning-content.html',
			            controller: 'StepPanelController',
			            controllerAs: 'stepPanel',
			            placement: 'top',
			            position: {
			                top: 200,
			                left: 100
			            }
			        }, {
			            title: 'Step 4:',
			            templateUrl: 'trainning-content.html',
			            controller: 'StepPanelController',
			            controllerAs: 'stepPanel',
			            placement: 'bottom',
			            position: '#startAgain'
			        }, {
			            stepClass: 'last-step',
			            backdropClass: 'last-backdrop',
			            templateUrl: 'trainning-content-done.html',
			            controller: 'StepPanelController',
			            controllerAs: 'stepPanel',
			            position: ['$window', 'stepPanel', function($window, stepPanel) {
			                // 自定义函数，使其屏幕居中
			                var win = angular.element($window);
			                return {
			                    top: (win.height() - stepPanel.height()) / 2,
			                    left: (win.width() - stepPanel.width()) / 2
			                }
			            }]
			        }]
			    })


本文插件源码和演示效果唯一codepen上，效果如下：

<p data-height="385" data-theme-id="0" data-slug-hash="pjwXQW" data-default-tab="result" data-user="greengerong" class='codepen'>See the Pen <a href='http://codepen.io/greengerong/pen/pjwXQW/'>ng-trainning</a> by green (<a href='http://codepen.io/greengerong'>@greengerong</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>


在trainning插件的源码设计中，包含如下几个要点：

* 提供service api。因为关于trainning这个插件，它是一个全局的插件，正好在Angular中所有的service也是单例的，所以将用户引导逻辑封装到Angular的service中是一个不错的设计。但对于trainning的每一步展示内容信息则是DOM操作，在Angular的处理中它不该存在于service中，最佳的方式是应该把他封装到Directive中。所以这里采用Directive的定义，并在service中compile，然后append到body中。
* 对于每一个这类独立的插件应该封装一个独立的scope，这样便于在后续的销毁，以及不会与现有的scope变量的冲突。
* $q对延时触发的结果包装。对于像该trainning插件或者modal这类操作结果采用promise的封装，是一个不错的选择。它取代了回调参数的复杂性，并以流畅API的方式展现，更利于代码的可读性。同时也能与其他Angular service统一返回API。
* 对于controller、controllerAs、resolve、template、templateUrl这类类似路由的处理代码，完全可以移到到你的同类插件中去。它们可以增加插件的更多定制化扩展。关于这部分代码的解释，博主将会在后续文章中为大家推送。
* 利用$injector.invoke动态注入和调用Angular service，这样既能获取Angular其他service注入的扩展性，也能获取到函数的动态性。如上例中的屏幕居中的自定义扩展方式。

这类设计要点，同样可以运用到想modal、alert、overload这类全局插件中。有兴趣的读者，你情可以在博主的codepen笔记中阅读这段代码[http://codepen.io/greengerong/pen/pjwXQW#0](http://codepen.io/greengerong/pen/pjwXQW#0)。

