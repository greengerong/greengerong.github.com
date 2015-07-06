---
layout: post
title: "angular Module声明获取重载"
date: 2015-07-06 08:30:33 +0800
comments: true
categories: [JavaScript, angular]
---
module是angular中重要的模块组织方式，它提供了将一组内聚的业务组件（controller、service、filter、directive...）封装在一起的能力。这样做可以将代码按照业务领域问题分module的封装，然后利用module的依赖注入其关联的模块内容，使得我们能够更好的”分离关注点“，达到更好的”高内聚低耦合“。”高内聚低耦合“是来自面向对象设计原则。内聚是指模块或者对象内部的完整性，一组紧密联系的逻辑应该被封装在同一模块、对象等代码单元中，而不是分散在各处；耦合则指模块、对象等代码单元之间的依赖程度，如果一个模块的修改，会影响到另一个模块，则说明这两模块之间是相互依赖紧耦合的。

同时module也是我们angular代码的入口，首先需要声明module，然后才能定义angular中的其他组件元素，如controller、service、filter、directive、config代码块、run代码块等。

关于module的定义为：angular.module('com.ngbook.demo', [])。关于module函数可以传递3个参数，它们分别为：

1. name：模块定义的名称，它应该是一个唯一的必选参数，它会在后边被其他模块注入或者是在ngAPP指令中声明应用程序主模块；
2. requires：模块的依赖，它是声明本模块需要依赖的其他模块的参数。特别注意：如果在这里没有声明模块的依赖，则我们是无法在模块中使用依赖模块的任何组件的；它是个可选参数。
3. configFn： 模块的启动配置函数，在angular config阶段会调用该函数，对模块中的组件进行实例化对象实例之前的特定配置，如我们常见的对$routeProvider配置应用程序的路由信息。它等同于”module.config“函数，建议用”module.config“函数替换它。这也是个可选参数。

对于angular.module方法，我们常用的方式有有种，分别为angular.module('com.ngbook.demo', [可选依赖])和angular.module('com.ngbook.demo')。请注意它是完全不同的方式，一个是声明创建module，而另外一个则是获取已经声明了的module。在应用程序中，对module的声明应该有且只有一次；对于获取module，则可以有多次。推荐将angular组件独立分离在不同的文件中，module文件中声明module，其他组件则引入module，需要注意的是在打包或者script方式引入的时候，我们需要首先加载module声明文件，然后才能加载其他组件模块。
 
在angular中文社区群中，有时会听见某些同学问关于”ng:areq“的错误：

	 [ng:areq] Argument 'DemoCtrl' is not a function, got undefined！

这往往是因为忘记定义controller或者是声明了多次module，多次声明module会导致前边的module定义信息被清空，所以程序就会找不到已定义的组件。这我们也能从angular源码中了解到（来自loader.js）：

	function setupModuleLoader(window) {
	            ...
	            function ensure(obj, name, factory) {
	                return obj[name] || (obj[name] = factory());
	            }
	            var angular = ensure(window, 'angular', Object);
	            return ensure(angular, 'module', function() {
	                var modules = {};
	                return function module(name, requires, configFn) {
	                    var assertNotHasOwnProperty = function(name, context) {
	                        if (name === 'hasOwnProperty') {
	                            throw ngMinErr('badname', 'hasOwnProperty is not a valid {0} name', context);
	                        }
	                    };

	                    assertNotHasOwnProperty(name, 'module');
	                    if (requires && modules.hasOwnProperty(name)) {
	                        modules[name] = null;
	                    }
	                    return ensure(modules, name, function() {
	                        if (!requires) {
	                            throw $injectorMinErr('nomod', "Module '{0}' is not available! You either misspelled " +
	                                "the module name or forgot to load it. If registering a module ensure that you " +
	                                "specify the dependencies as the second argument.", name);
	                        }
	                        var invokeQueue = [];
	                        var runBlocks = [];
	                        var config = invokeLater('$injector', 'invoke');
	                        var moduleInstance = {
	                            _invokeQueue: invokeQueue,
	                            _runBlocks: runBlocks,
	                            requires: requires,
	                            name: name,
	                            provider: invokeLater('$provide', 'provider'),
	                            factory: invokeLater('$provide', 'factory'),
	                            service: invokeLater('$provide', 'service'),
	                            value: invokeLater('$provide', 'value'),
	                            constant: invokeLater('$provide', 'constant', 'unshift'),
	                            animation: invokeLater('$animateProvider', 'register'),
	                            filter: invokeLater('$filterProvider', 'register'),
	                            controller: invokeLater('$controllerProvider', 'register'),
	                            directive: invokeLater('$compileProvider', 'directive'),
	                            config: config,
	                            run: function(block) {
	                                runBlocks.push(block);
	                                return this;
	                            }
	                        };
	                        if (configFn) {
	                            config(configFn);
	                        }
	                        return moduleInstance;

	                        function invokeLater(provider, method, insertMethod) {
	                            return function() {
	                                invokeQueue[insertMethod || 'push']([provider, method, arguments]);
	                                return moduleInstance;
	                            };
	                        }
	                    });
	                };
	            });
	        }

在代码中，我们能了解到angular在启动时，会设置全局的angular对象，然后在angular对象上发布module这个API。关于module API代码，能清晰的看见第一行谓语句，module名称不能以hasOwnProperty命名，否则会抛出”badname“的错误信息。紧接着，如果传入了name参数，其表示是声明module，则会删除已有的module信息，将其置为null。

从moduleInstance的定义，我们能够看出，angular.module为我们公开的API有：_invokeQueue、_runBlocks、requires、name、provider、factory、servic、value、constant、animation、filter、controller、directive、config、run。其中_invokeQueue和_runBlocks是按名约定的私有属性，请不要随意使用，其他API都是我们常用的angular组件定义方法，从invokeLater代码中能看到这类angular组件定义的返回依然是moduleInstance实例，这就形成了流畅API，推荐使用链式定义这些组件，而不是声明一个全局的module变量。

最后，如果传入了第三个参数configFn，则会将它配置到config信息中，当angular进入config阶段时，它们将会依次执行，进行对angular应用或者angular组件如service等的实例化前的配置。