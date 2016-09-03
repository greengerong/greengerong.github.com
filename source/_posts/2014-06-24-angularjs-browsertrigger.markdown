---
layout: post
title: "angularjs之browserTrigger"
date: 2014-06-24 20:42:33 +0800
comments: true
categories: [angularjs,javascript]
---
今天推荐一款来自angularjs源码的单元测试辅助库browserTrigger，这是来自于ngScenario的一段代码。主要用户触发浏览器型行为更新ng中scope view model的值。

这是angularjs源码中单元测试的使用browserTrigger的实例：


	it('should set the model to empty string when empty option is selected', function() {
        scope.robot = 'x';
        compile('<select ng-model="robot">' +
                  '<option value="">--select--</option>' +
                  '<option value="x">robot x</option>' +
                  '<option value="y">robot y</option>' +
                '</select>');
        expect(element).toEqualSelect('', ['x'], 'y');

        browserTrigger(element.find('option').eq(0));
        expect(element).toEqualSelect([''], 'x', 'y');
        expect(scope.robot).toBe('');
      });


在这段代码中给browserTrigger传入你希望选择的select option，则它会帮助你tigger change，选中当前option，更触发更新ng select的viewmodel。

在browserTrigger中还为我们做了很多其他输入框或者html控件的触发接口，同时也加入了浏览器的兼容性。使得我们的测试更加方便不用考虑浏览器兼容性或者不同的html控件trigger不同的事件去更新scope的值。

具体更多信息请参考[ng的官方测试](https://github.com/angular/angular.js/blob/accd35b7471bbf58cd5b569a004824fa60fa640a/test/ng/directive/selectSpec.js)和[browserTrigger源码](https://raw.githubusercontent.com/angular/angular.js/dafb8a3cd12e7c3247838f536c25eb796331658d/src/ngScenario/browserTrigger.js)。

