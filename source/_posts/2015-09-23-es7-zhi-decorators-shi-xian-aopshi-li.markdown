---
layout: post
title: "ES7之Decorators实现AOP示例"
date: 2015-09-23 07:11:07 +0800
comments: true
categories: [javascript,es7,decorators]
---
在上篇博文[CoffeeScript实现Python装潢器](http://greengerong.com/blog/2015/09/22/coffeescript-shi-xian-python-zhuang-huang-qi/)中，笔者利用CoffeeScript支持的高阶函数，以及方法调用可省略括符的特性，实现了一个类似Python装潢器的日志Demo。这只是一种伪实现，JavaScript实现装潢器，我们需要等到ECMAScript7才行，在ES7特性中带来了Decorators，它就是我们所需要的装潢器特性。但虽然它是ES7的特性，但在Babel流行了今天，我们可以利用Babel来使用它。关于Babel的推荐文章，请参见另一篇文章[Babel-现在开始使用 ES6](http://greengerong.com/blog/2015/03/22/babel-kai-shi-es6ti-yan/)。

下面我们让然和上节[CoffeeScript实现Python装潢器](http://greengerong.com/blog/2015/09/22/coffeescript-shi-xian-python-zhuang-huang-qi/)一样来实现一个ES7 Decorators版的日志拦截示例。我们希望的使用如下：

	class MyClass {
	  @log('MyClass add')
	  add(a, b){
	    return a + b;
	  }
	  @log('MyClass product')
	  product(a, b){
	    return a * b;
	  }
	  @log('MyClass error')
	  error(){
	     throw 'Something is wrong!';
	   }
	}

在ES7中Decorators，也是一个函数，我们只需要在它前面加上@符号，并将它标注在特定的目标，如class、method等，则可以实现方法的包裹拦截。它的传入参数有：target, name, descriptor。它们分别标记目标，标记目标名称，以及目标描述信息。在descriptor中，包括configurable、enumerable、writable，value四个属性。它们分别可以控制目标的读写、枚举，以及目标值。

所以我们可以如下实现：

	let log = (type) => {
	    const logger = new Logger('#console');
	    return (target, name, descriptor) => {
	      const method = descriptor.value;
	      descriptor.value =  (...args) => {
	            logger.info(`(${type}) before function execute: ${name}(${args}) = ?`);
	            let ret;
	            try {
	                ret = method.apply(target, args);
	                logger.info(`(${type})after function execute success: ${name}(${args}) => ${ret}`);
	            } catch (error) {
	                logger.error(`(${type}) function execute error: ${name}(${args}) => ${error}`);
	            } finally {
	                logger.info(`(${type}) function execute done: ${name}(${args}) => ${ret}`);
	            }
	            return ret;
	        }
	    }
	}

首先存储原来方法体，再等到调用时，实现方法调用前后的日志拦截，打印相关信息。它的效果如下：

![es7 decorators log aop](/images/blog_img/es7-decorators-log-aop.png)

整个demo示例，你也可以在codepen上细细把玩：

<p data-height="350" data-theme-id="0" data-slug-hash="epzbMV" data-default-tab="result" data-user="greengerong" class='codepen'>See the Pen <a href='http://codepen.io/greengerong/pen/epzbMV/'>ES7 Decorators</a> by green (<a href='http://codepen.io/greengerong'>@greengerong</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

