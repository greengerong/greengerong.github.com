---
layout: post
title: "ngModel 值不更新/显示"
date: 2015-06-29 06:50:10 +0800
comments: true
categories: [angular,JavaScript]
---
angular中的$scope是页面（view）和数据（model）之间的桥梁，它链接了页面元素和model，也是angular双向绑定机制的核心。

而ngModel是angular用来处理表单（form）的最重要的指令，它链接了页面表单中的可交互元素和位于$scope之上的model，它会自动把ngModel所指向的model值渲染到form表单的可交互元素上，同时也会根据用户在form表单的输入或交互来更新此model值。

在源码中，model值的格式化、解析、验证都是由ngModel指令所对应的控制器ngModelController来实现的。

在笔者所维护的国内ng群中，经常被问到一个问题：

		为什么我的ng-model=“xxx”值不能在页面显示了呢?

对于ngModel的这类问题主要分为两类：

- model值不满足表单验证条件,所以angular不会渲染它
- 由于JavaScript特殊的原型链继承机制，对$scope中属性的赋值并不能更新到父$scope

在本节中，我们将会详细分析此类问题，借此深入剖析ngModel的工作原理。

####验证引起的model值不显示

我们先来看一个修改商品数量的例子，要求为必须输入1-100的个数；

下面是对应的html代码：

	<body class="container">
	  <div ng-controller="DemoCtrl as demo">
	   <div ng-form="form" class="form-horizontal">
	      <div class="form-group" ng-class="{'has-error': form.amount.$invalid }">
	      <label for="amount">Amount</label>
	      <!-- 这个input将工作不正常 -->
	    <input id="amount" name="amount" type="number" ng-model="demo.amount" class="form-control" placeholder="1 - 100" min="1" max="100"/>
	    </div>
	  </div>
	   </div>
	</body>

javascript代码：

	angular.module("com.ngbook.demo", [])
	    .controller("DemoCtrl", [function(){
	    var vm = this;
	      
	    vm.amount = 0;
	      
	    return vm;
	}]);
     
 在代码中我们已经为ngModel变量amount赋值了整数“0”，可是界面显示效果仍然显示"1 - 100"的placeholder(如下图)。
![ng-model绑定值不改变:验证](/images/blog_img/ngModel-vadation-question.png)

下面是关于angular number组件ngModel转换函数代码：

	var NUMBER_REGEXP = /^\s*(\-|\+)?(\d+|(\d*(\.\d*)))\s*$/;

	function numberInputType(scope, element, attr, ctrl, $sniffer, $browser) {
	    textInputType(scope, element, attr, ctrl, $sniffer, $browser);

	    ctrl.$parsers.push(function(value) {
	        var empty = ctrl.$isEmpty(value);
	        if (empty || NUMBER_REGEXP.test(value)) {
	            ctrl.$setValidity('number', true);
	            return value === '' ? null : (empty ? value : parseFloat(value));
	        } else {
	            ctrl.$setValidity('number', false);
	            return undefined;
	        }
	    });

	    addNativeHtml5Validators(ctrl, 'number', numberBadFlags, null, ctrl.$$validityState);

	    ctrl.$formatters.push(function(value) {
	        return ctrl.$isEmpty(value) ? '' : '' + value;
	    });

	    if (attr.min) {
	        var minValidator = function(value) {
	            var min = parseFloat(attr.min);
	            return validate(ctrl, 'min', ctrl.$isEmpty(value) || value >= min, value);
	        };

	        ctrl.$parsers.push(minValidator);
	        ctrl.$formatters.push(minValidator);
	    }

	    if (attr.max) {
	        var maxValidator = function(value) {
	            var max = parseFloat(attr.max);
	            return validate(ctrl, 'max', ctrl.$isEmpty(value) || value <= max, value);
	        };

	        ctrl.$parsers.push(maxValidator);
	        ctrl.$formatters.push(maxValidator);
	    }

	    ctrl.$formatters.push(function(value) {
	        return validate(ctrl, 'number', ctrl.$isEmpty(value) || isNumber(value), value);
	    });
	}


ngModel作为angular双向绑定中的重要组成部分，负责view控件交互数据到$scope上model的同步。当然这里存在一些差异，view上的显示和输入都是字符串类型，而在model上的数据则是有特定类型的，如常用的int、float、Date、Array、Object等。ngModel为了实现数据到model的类型转换，在ngModelController中提供了两个管道数组$formatters和$parsers，它们分别是将model的数据转换为view交互控件显示的值和将交互控件得到的view值转换为model数据，它们都是一个数组对象，在ngModel启动数据转换时，会以UNIX管道式传递执行这一些列的转换。我们也可以手动的添加$formatters和$parsers的转换函数（unshift、push），当然在这里也是做数据验证的最佳时机，能够转换意味应该是合法的数据。

在number组件代码中，我们清晰看见：依次添加了对数字验证转换、最小值合法性验证、最大值合法验证。首先会启动$parsers转换，如果在转换过程中出现不合法验证则会设置ngModelController.$setValidity验证错误，则返回undefined。对于model数据到交互控件显示，同样也会经过$formatters转换管道，对于没有通过验证的逻辑，同样也会ngModelController.$setValidity设置验证错误，返回undefined，因此这不合法的model数据不会显示在交互控件上。

####原型链继承问题
JavaScript中每个对象都会链接到一个原型对象，并且他可以从中继承属性。即使通过字面量创建的对象也会链接到Object.prototype，它是JavaScript中的标配对象。JavaScript的原型链继承相对于其他语言常见的继承，是一种另类的继承，它是实施于对象上的动态继承方式，而非常见的实施与类型class之上的静态继承体系。JavaScript的这种继承方式很灵活，一个对象可以被多个对象继承，而且他们共享同一实例对象，但理解起来显得格外复杂，从JavaScript原型和原型链可以看出它的复杂性。在Javascript中，每个函数都有一个原型属性prototype指向自身的原型，而由这个函数创建的对象也有一个__proto__属性指向这个原型，而函数的原型是一个对象，所以这个对象也会有一个__proto__指向自己的原型，这样逐层深入直到Object对象的原型，这样就形成了原型链。下面的是JavaScript原型继承基础原型和原型链展示图。

![javascript-原型继承](/images/blog_img/javascript-原型继承.png)

函数是由Function函数创建的对象，因此函数也有一个__proto__属性指向Function函数的原型。需要注意的是，真正形成原型链的是每个对象的__proto__属性，而不是函数的prototype属性。更多的内容关于原型和原型链的知识，请参考《Javascript模式》这本书。

JavaScript的原型链连接只在属性检索的时候才会启用，如果我们尝试去获取对象的某个属性值，但该对象没有此属性名，则JavaScript会试着从原型对象中获取该属性值。如果那个对象也没有该属性名，那么在继续从它的原型中寻找，依次类推，直到Object.prototype，如果仍然没有找到该属性值，则返回结果为undefined。不幸的是，这种原型链连接检索，只会在属性检索的的时候启用，并不会在更新属性值时启用，因此当我们对于基础类型（非引用对象上的属性，换句通俗的话来说，就是不会出现“.”运算符）的属性更新的时候，它并不能更新父对象的属性，替代方式是在自身对象上创建了该属性。这也是angular中对于基础类型的属性，不能在子controller中被修改的原因，导致在子controller中ngModel的更新并不会反应在父controller上。

下边是关于该问题的一个简化例子：

HTML：

	<div ng-controller="ParentCtrl">
	    <div class="form-group">
	        <h4>Parent Controller:</h4>
	        <pre>{{ greet | json}}</pre>
	        <input type="text" ng-model="greet" class="form-control" />
	    </div>
	    <div ng-controller="ChildCtrl">
	        <div class="form-group">
	            <h4>Child controller:</h4>
	            <pre>{{ greet | json}}</pre>
	            <input type="text" ng-model="greet" class="form-control" />
	        </div>
	    </div>
	</div>

JavaScript：

	angular.module("com.ngbook.demo", [])
	    .controller("ParentCtrl", ["$scope", function($scope) {

	        $scope.greet = "hello angular!";

	    }])
	    .controller("ChildCtrl", angular.noop);


从初始化显示效果中，我们能看出子$scope之继承了来自父$scope的greet属性，都显示为"hello angular!"。如果我们尝试利用父controller提供了input控件改变父$scope的greet属性，你也能看见子controller区域的显示也会被及时更新。对于ngController默认会使用原型链继承其父对象的属性，所有的$scope的根$scope或称祖$scope是来自ngApp节点创建的$rootScope，换句话说，$rootScope是万物之源，所有的$scope都直接或者间接继承至它。

![ngModel-controller继承](/images/blog_img/ngModel-值不更新-javascript-issue-1.png)

当我们尝试去改变输入框的greet属性的时，则发生了下面的情况：子controller区域发生了更新，父controller区域却无法更新。因为上面所说的JavaScript的原型链检索并不对更新启用，对于基础类型JavaScript在自身对象（这里是子$scope）上创建了一个同名的变量。你也想可以从下面angular调试插件batarang截图中看出来。一旦利用子controller的input控件修改了greet属性，再次之后我再次尝试修改父controller区域的greet属性，子controller区别不会在像初始化时候那样及时同步了，它们之间完全独立了，各自拥有了自己的greet属性。

![ngModel-controller继承](/images/blog_img/ngModel-值不更新-javascript-issue-2.png)

batarang插件截图

![ngModel-controller继承](/images/blog_img/ngModel-值不更新-javascript-issue-3.png)

经过上面的例子分析，相信作为读者的你已经能够理解这类由于继承链引用问题导致的ngModel不能更新问题了，请记住：这是JavaScript原型继承的issue，并不是angular的issue。

那么我们在子controller中如何更新父controller的属性值呢？这个问题已经很简单了，issue的问题在于没有启用原型链的检索，那么如果我们将ngModel的属性变为引用对象，换句话说：在ngModel的属性值中加了“.”，那么在JavaScript的原型链检索就会启动了。

HTML:

	<div ng-controller="ParentCtrl">
	    <div class="form-group">
	        <h4>Parent Controller:</h4>
	        <pre>{{ vm.greet | json}}</pre>
	        <input type="text" ng-model="vm.greet" class="form-control" />
	    </div>
	    <div ng-controller="ChildCtrl">
	        <div class="form-group">
	            <h4>Child controller:</h4>
	            <pre>{{ vm.greet | json}}</pre>
	            <input type="text" ng-model="vm.greet" class="form-control" />
	        </div>
	    </div>
	</div>

JavaScript:

	angular.module("com.ngbook.demo", [])
	    .controller("ParentCtrl", ["$scope", function($scope) {

	        $scope.vm = {
	            greet: "hello angular!"
	        };

	    }])
	    .controller("ChildCtrl", angular.noop);

jsbin demo: http://jsbin.com/metufi/1/edit?html,js,output
这里在ngModel属性值多引入了“vm”变量，这个时候，不管我们尝试修改greet值，整个页面都会得到相应的同步。关于这个问题，作者更推荐使用angular 1.2后的controller as vm的方式解决，更多的信息请阅读《使用controller as vm方式.md》一节。