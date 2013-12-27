---
layout: post
title: "angularjs组件之input mask"
description: ""
category: "angularjs"
tags: [angularjs]
---
今天将奉献一个在在几个angularjs项目中抽离的angular组件 input mask。在我们开发中经常会对用户的输入进行控制，比如日期，货币格式，或者纯数字格式之类的限制，这就是input mask的使用场景，在项目中也是会经常被提及需的需求之一。

当然在官方的angular-ui ui-utils中有一个相应的组件叫做ui-mask，但是其mask功能是很初级脆弱的。所以我希望能得到一个更强大的mask组件。我所知的[jquery.inputmask](https://github.com/RobinHerbots/jquery.inputmask)就是这样一个我所期望的强大的mask组件，所以我不必再去重造轮子，好的软件就是为了不停被重复利用。所以写了一个adapter，[https://github.com/greengerong/green.inputmask4angular](https://github.com/greengerong/green.inputmask4angular).

其使用如下，可以去下载项目查看其中的demo page。

	
	<div class="hero-unit">
                    <h1>'Allo, 'Allo!</h1>

                    <div>
                        <h3>mask</h3>
                        <p>Mask: 99-9999999</p>
                        <input type="text" ng-model="test" input-mask="'mask'" mask-option="testoption"/>
                        <pre>{{ test | json }}</pre>
                    </div>

                    <div>
                        <h3>y-m-d</h3>
                        <p>Date: yyyy-MM-dd</p>
                        <input type="text" ng-model="test1" input-mask="'y-m-d'" format-option="dateFormatOption"/>
                        <pre>{{ test1 | json }}</pre>
                    </div>


                    <div>
                        <h3>Regex</h3>
                        <p>Email: "[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,4}"</p>
                        <input type="text" ng-model="test3" input-mask="'Regex'"
                         mask-option="regexOption"/>
                        <pre>{{ test3 | json }}</pre>
                    </div>

                    <div>
                        <h3>Function</h3>
                        <p>"[1-]AAA-999" or  "[1-]999-AAA"</p>
                        <input type="text" ng-model="test4" input-mask="functionOption"/>
                        <pre>{{ test4 | json }}</pre>
                    </div>

                </div>
                
                
 controller code:
 
 
 	'use strict';

        angular.module('green.inputmaskApp')
            .controller('MainCtrl', ["$scope", function ($scope) {

                $scope.testoption = {
                    "mask": "99-9999999",
                    "oncomplete": function () {
                        console.log();
                        console.log(arguments,"oncomplete!this log form controler");
                    },
                    "onKeyValidation": function () {
                        console.log("onKeyValidation event happend! this log form controler");
                    }
                }

                //default value
                $scope.test1 = new Date();

                $scope.dateFormatOption = {
                    parser: function (viewValue) {
                        return viewValue ? new Date(viewValue) : undefined;
                    },
                    formatter: function (modelValue) {
                        if (!modelValue) {
                            return "";
                        }
                        var date = new Date(modelValue);
                        return (date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate()).replace(/\b(\d)\b/g, "0$1");
                    },
                    isEmpty: function (modelValue) {
                        return !modelValue;
                    }
                };


                $scope.mask = { regex: ["999.999", "aa-aa-aa"]};


                $scope.regexOption = {
                    regex: "[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,4}"
                };

                $scope.functionOption = {
                 mask: function () { 
                    return ["[1-]AAA-999", "[1-]999-AAA"]; 
                }};


            }]);
            

这里值列列举了jquery.inputmask的简单实用方式，更复杂的方式请移步到jquery.inputmask查看。

