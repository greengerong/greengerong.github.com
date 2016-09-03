---
layout: post
title: "细说angular form addControl方法"
date: 2014-02-21 17:24:37 +0800
comments: true
category: "angularjs"
tags: [angular,javascript]
---
在本篇博文中，我们将接触angular的验证。angular的验证是由form 指令和ngModel协调完成的。今天博主在这里想要说的是在验证在的一种特殊情况，当验证控件没有没有name属性这是不会被form捕获的。或者是你希望在ngRepeat中使用动态表达式。

下面且让我们先来从angular源码中看起如下：

首先是ngModel：

        var ngModelDirective = function() {
          return {
            require: ['ngModel', '^?form'],
            controller: NgModelController,
            link: function(scope, element, attr, ctrls) {
              // notify others, especially parent forms

              var modelCtrl = ctrls[0],
                  formCtrl = ctrls[1] || nullFormCtrl;

              formCtrl.$addControl(modelCtrl);

              scope.$on('$destroy', function() {
                formCtrl.$removeControl(modelCtrl);
              });
            }
          };
        };

从上面我们能够看出ngModel指令会在编译时期的post link阶段会通过form的 **addControl**方法把自己的controller注册到父节点上的form的formController中。

在看看ngModel controller初始化代码：

        var NgModelController = ['$scope', '$exceptionHandler', '$attrs', '$element', '$parse',
            function($scope, $exceptionHandler, $attr, $element, $parse) {
         ....
          this.$pristine = true;
          this.$dirty = false;
          this.$valid = true;
          this.$invalid = false;
          this.$name = $attr.name;

我们从上面我们可以看到 **ngModel的$name属性并不支持表达式计算**。

而FormController的addControl代码则是：

        /**
         * @ngdoc function
         * @name ng.directive:form.FormController#$addControl
         * @methodOf ng.directive:form.FormController
         *
         * @description
         * Register a control with the form.
         *
         * Input elements using ngModelController do this automatically when they are linked.
         */
        form.$addControl = function(control) {
          // Breaking change - before, inputs whose name was "hasOwnProperty" were quietly ignored
          // and not added to the scope.  Now we throw an error.
          assertNotHasOwnProperty(control.$name, 'input');
          controls.push(control);

          if (control.$name) {
            form[control.$name] = control;
          }
        };
        

从上面我们可以清楚的看见虽然ngModel注册了自己，但是这里也不一定能注册成功，**ngModel心必须有自己的$name才能被注册成功**。

从上面的代码中可以得出，当我们的验证失效的时候，我们可以有一个万能的方式就是 **手动注册到form controller**

###手动注册form controller

为了我写了一个dy-name的插件，其会在post link阶段解析表达式，并把自己注册到父form controller。

如下：

        .directive("dyName", [

            function() {
              return {
                require: "ngModel",
                link: function(scope, elm, iAttrs, ngModelCtr) {
                  ngModelCtr.$name = scope.$eval(iAttrs.dyName)
                  var formController = elm.controller('form') || {
                    $addControl: angular.noop
                  };
                  formController.$addControl(ngModelCtr);

                  scope.$on('$destroy', function() {
                    formController.$removeControl(ngModelCtr);
                  });

                }
              };
            }
          ])

使用方式：


        <div ng-repeat="item in demo.fields">
          <div class="control-group">
            <label class="control-label">{{item.label }} : </label>
            <div class="controls">
              <input type="number"  dy-name="item.field" ng-model="demo.data[item.field]" min="10" max="500" ng-required="true"/>
            </div>
          </div>
        </div>

其实实现为在post link阶段获取到form controller，并把自己注册到form controller，而且为了消除对象的级联，将会在scope摧毁阶段remove自己。

其效果请看[jsbin $addControl](http://jsbin.com/docow/1/edit?html,js,output)

**注意**:在formController.$addControl方法的参数传入的不是界面控件，而是ngModelController.或者名字为$addController更合适。


           