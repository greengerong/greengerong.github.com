---
layout: post
title: "JavaScript函数柯里化"
date: 2015-05-11 19:37:18 +0800
comments: true
categories: [JavaScript]
---

####函数式
JavaScript是以函数为一等公民的函数式语言。函数在JavaScript中也是一个对象（继承制Function），函数也可以作为参数传递成函数变量。最近几年函数式也因为其无副作用的特性、透明性、惰性计算等在高并发，大数据领域火起来了。

JavaScript中也有如Underscore、lodash之类的函数式库，如lodash的使用方式：

```javascript
	var names = _.chain(users)
	  .map(function(user){
	    return user.user;
	  })
	  .join(" , ")
	  .value();
	console.log(names);
```

关于lodash更多内容请参考[JavaScript工具库之Lodash](http://www.cnblogs.com/whitewolf/p/4417873.html).

####柯里化
今天文章将以高阶函数中的柯里化方式来，看看JavaScript的函数式能力。

在计算机科学中，柯里化（Currying）是把接受多个参数的函数变换成接受一个单一参数(最初函数的第一个参数)的函数，并且返回接受余下的参数且返回结果的新函数的技术。这个技术由 Christopher Strachey 以逻辑学家 Haskell Curry 命名的，尽管它是 Moses Schnfinkel 和 Gottlob Frege 发明的。

在理论计算机科学中，柯里化提供了在简单的理论模型中比如只接受一个单一参数的lambda 演算中研究带有多个参数的函数的方式。

####JavaScript的柯里化实现

下边的例子，我们将把柯里化方式泛化为接受任意个参数，直到声明的方法参数个数饱和才执行，所以根据参数个数可以有多种柯里化函数产生。

代码如下：

```javascript
	(function(global) {
	    var FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m,
	        FN_ARG_SPLIT = /,/,
	        FN_ARG = /^\s*(_?)(\S+?)\1\s*$/,
	        STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;

	    var getArgLength = function(func) {
	        var fnText = func.toString().replace(STRIP_COMMENTS, '');
	        var argDecl = fnText.match(FN_ARGS);
	        var params = [];
	        argDecl[1].split(FN_ARG_SPLIT).forEach(function(arg) {
	            arg.replace(FN_ARG, function(all, underscore, name) {
	                params.push(name);
	            });
	        });
	        return params.length;
	    };

	    var curryFunc = function(func, len) {
	        len = len || getArgLength(func);
	        var args = [];
	        if (len === 0) {
	            return func.apply(null);
	        }

	        return function() {
	            [].push.apply(args, [].slice.apply(arguments));
	            if (args.length >= len) {
	                return func.apply(null, args);
	            }

	            return arguments.callee;
	        };
	    };

	    global.curryFunc = curryFunc;
	})(this);

	function add(x, y, z) {
	    return x + y + z;
	}

	console.log("result 1:", curryFunc(add)(1, 2)(3));
	console.log("result 2:", curryFunc(add)(1)(2, 3));
	console.log("result 3:", curryFunc(add)(1)(3)(2));

	function add(x, y, z) {
	    return x * y * z;
	}

	console.log("result 1:", curryFunc(add)(2, 4)(6));
	console.log("result 2:", curryFunc(add)(2)(4, 6));
	console.log("result 3:", curryFunc(add)(2)(6)(4));

	function sayHello() {
	    return "hello";
	}
	console.log(curryFunc(sayHello));
```

首先上面会利用正则来获取传入函数的参数个数。再返回一个函数的代理，每次的调用都会将传入参数缓存在args临时变量中，直到参数个数饱和才会立即执行。代码比较冗长，慢慢品味，当然有不足支持，也希望大家指出来。


