---
layout: post
title: "ES7 JavaScript Decorators"
date: 2015-09-24 15:00:40 +0800
comments: true
categories: [es7, javascript, decorators]
---

##开篇概述

在上篇的[ES7之Decorators实现AOP示例](http://greengerong.com/blog/2015/09/23/es7-zhi-decorators-shi-xian-aopshi-li/)中，我们预先体验了ES7的Decorators，虽然只是一个简单的日志AOP拦截实现。但是它足以让我们体会到ES7 Decorators的强大魅力所在。所谓为什么博主会为它而专门写作此文。在Angular2中的TypeScript Annotate就是标注装潢器的另一类实现。同样如果你也是一个React的爱好者，你应该已经发现了redux2中也开始利用ES7的Decorators进行了大量重构。

尝试过Python的同学们，我相信你做难忘的应该是装潢器。由[Yehuda Katz](https://github.com/wycats)提出的[decorator模式](https://github.com/wycats/javascript-decorators)，就是借鉴于Python的这一特性。作为读者的你，可以从上一篇博文[ES7之Decorators实现AOP示例](http://greengerong.com/blog/2015/09/23/es7-zhi-decorators-shi-xian-aopshi-li/)中看到它们之间的联系。

##Decorators

####背后原理

ES7的Decorators让我们能够在设计时对类、属性等进行标注和修改成为了可能。Decorators利用了ES5的

	Object.defineProperty(target, name, descriptor);

来实现这一特性。如果你还不了解Object.defineProperty，请参见[MDN文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)。首先我们来考虑一个普通的ES6类：

	class Person {
	  name() { return `${this.first} ${this.last}` }
	}


执行这一段class，给Person.prototype注册一个name属性，粗略的和如下代码相似：

	Object.defineProperty(Person.prototype, 'name', {
	  value: specifiedFunction,
	  enumerable: false,
	  configurable: true,
	  writable: true
	});

如果利用装潢器来标注一个属性呢？

	class Person {
	  @readonly
	  name() { return `${this.first} ${this.last}` }
	}


在这种装潢下的属性，则会在利用Object.defineProperty为Person.prototype注册name属性之前，执行这段装潢器：

	let descriptor = {
	  value: specifiedFunction,
	  enumerable: false,
	  configurable: true,enumerable、
	  writable: true
	};

	descriptor = readonly(Person.prototype, 'name', descriptor) || descriptor;
	Object.defineProperty(Person.prototype, 'name', descriptor);

从上面的伪代码中，我们能看出，装潢器只是在Object.defineProperty为Person.prototype注册属性之前，执行一个装饰函数，其属于一类对Object.defineProperty的拦截。所以它和Object.defineProperty具有一致的方法签名，它们的3个参数分别为：

1. obj：作用的目标对象；
2. prop：作用的属性名；
3. descriptor: 针对该属性的描述符。

这里最重要的是descriptor这个参数，它是一个数据或访问器的属性描述对象。在对数据和访问器属性描述时，它们都具有configurable、enumerable属性可用。而在数据描述时，value、writable属性则是数据所特有的。get、set属性则是访问器属性描述所特有的。属性描述器中的属性决定了对象prop属性的一些特性。比如 enumerable，它决定了目标对象是否可被枚举，能够在for…in循环中遍历到，或者出现在Object.keys法的返回值中；writable则决定了目标对象的属性是否可以被更改。完整的属性描述，请参见[MDN文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty#Description)。

对于descriptor中的属性，它们可以被我们在Decorators中使用，或者修改的，以达到我们标注或者拦截的目的。这也是装潢器拦截的主体信息。

####作用于访问器

装潢器也可以作用与属性的getter/setter访问器之上，如下将属性标注为不可枚举的代码：

	class Person {
	  @nonenumerable
	  get kidCount() { return this.children.length; }
	}

	function nonenumerable(target, name, descriptor) {
	  descriptor.enumerable = false;
	  return descriptor;
	}

下面是一个更复杂的对访问器的备用录模式运用：

	class Person {
	  @memoize
	  get name() { return `${this.first} ${this.last}` }
	  set name(val) {
	    let [first, last] = val.split(' ');
	    this.first = first;
	    this.last = last;
	  }
	}

	let memoized = new WeakMap();
	function memoize(target, name, descriptor) {
	  let getter = descriptor.get, setter = descriptor.set;

	  descriptor.get = function() {
	    let table = memoizationFor(this);
	    if (name in table) { return table[name]; }
	    return table[name] = getter.call(this);
	  }

	  descriptor.set = function(val) {
	    let table = memoizationFor(this);
	    setter.call(this, val);
	    table[name] = val;
	  }
	}

	function memoizationFor(obj) {
	  let table = memoized.get(obj);
	  if (!table) { table = Object.create(null); memoized.set(obj, table); }
	  return table;
	}	

####作用域类上

同样Decorators也可以为class装潢，如下对类是否annotated的标注：

	// A simple decorator
	@annotation
	class MyClass { }

	function annotation(target) {
	   // Add a property on target
	   target.annotated = true;
	}

####也可以是一个工厂方法

对于装潢器来说，它同样也可以是一个工厂方法，接受配置参数信息，并返回一个应用于目标函数的装换函数。如下例子，对类可测试性的标记：

	@isTestable(true)
	class MyClass { }

	function isTestable(value) {
	   return function decorator(target) {
	      target.isTestable = value;
	   }
	}

同样工厂方法，也可以被应用于属性之上，如下对可枚举属性的配置：

	class C {
	  @enumerable(false)
	  method() { }
	}

	function enumerable(value) {
	  return function (target, key, descriptor) {
	     descriptor.enumerable = value;
	     return descriptor;
	  }
	}

同样在上篇[ES7之Decorators实现AOP示例](http://greengerong.com/blog/2015/09/23/es7-zhi-decorators-shi-xian-aopshi-li/)中对于日志拦截的日志类型配置信息，也是利用工厂方法来实现的。它是一个更复杂的工厂方式的Decorators实现。

####后续

如上一篇博问所说：虽然它是ES7的特性，但在Babel大势流行的今天，我们可以利用Babel来使用它。我们可以利用Babel命令行工具，或者grunt、gulp、webpack的babel插件来使用Decorators。

关于ES7 Decorators的更有意思的玩法，你可以参见牛人实现的常用的Decorators：[core-decorators](https://github.com/jayphelps/core-decorators.js)。以及[raganwald](http://raganwald.com/)的[如何用Decorators来实现Mixin](http://raganwald.com/2015/06/26/decorators-in-es7.html)。




