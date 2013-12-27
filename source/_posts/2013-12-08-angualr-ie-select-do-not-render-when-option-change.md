---
layout: post
title: "angularjs位于ng-switch中的ng-option,当select option改变了在IE上不会重新渲染 issue解决方案"
description: ""
category: "angularjs"
tags: [angular,ie]
---

最近遇见angularjs 在IE上当使用ng-options作为select的选项数据源，并且被套在ng-switch（ng-transclude）之类的，当angular上得ng-options数据源model改变后，在IE上并不渲染。


在一阵的测试和阅读相关文档后最后确认为：因为ng-switch（ng-transclude）是为了使其scope为原来的父scope，在父scope上生成了DOM后才克隆(cloneNode)到指定的指令位置。然而IE在对于select克隆的节点，不会主动去触发重绘，所以才有了上面的issue。

问题确定了，那我们所需要做的就是手动的去触发让IE对Select重绘，尝试了很多办法后最终确认有效的是：首先在options上用原生js去添加一个option，在马上移除掉这个option，所以解决方案如下：
	
	angular.module('ie.select', [])
    .directive('ieSelectFix', [
        function () {
            return {
                restrict: 'A',
                require: 'select',
                link: function (scope, element, attributes) {
                    var isIE = document.attachEvent;
                    if (!isIE) return;

                    var control = element[0];
                    scope.$watch(attributes.ieSelectFix, function () {
                        //it should be use javascript way, not jquery way.
                        var option = document.createElement("option");
                        control.add(option, null);
                        control.remove(control.options.length - 1);
                    });
                }
            }
        }
    ]);



使用方式如下：

	
	<select ie-select-fix="options" ng-model="demos" class="form-control"
            ng-options="currOption.value as currOption.text for currOption in options">
        <option value="" default>Select</option>
    </select>



我也在我的github专门创建了一个针对angularjs在IE上issue的项目，收录了这个指令，在后续也会加入我所遇见的angularjs关于ie的issue，也希望大家帮助完善这个项目，让我们的angularjs程序在IE工作的更美好，让我们这些辛苦的程序猿也少一点加班时间，多一点陪家人，泡咖啡的时间。哈哈。


github项目地址：[https://github.com/greengerong/angular-ie-enhancer](https://github.com/greengerong/angular-ie-enhancer)