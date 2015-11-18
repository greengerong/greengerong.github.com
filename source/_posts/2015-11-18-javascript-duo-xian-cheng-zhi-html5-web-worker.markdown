---
layout: post
title: "JavaScript多线程之HTML5 Web Worker"
date: 2015-11-18 12:39:29 +0800
comments: true
categories: [html5, javascript]
---

在博主的前些文章[Promise的前世今生和妙用技巧](http://greengerong.com/blog/2015/10/22/promisede-miao-yong/)和[JavaScript单线程和浏览器事件循环简述](http://greengerong.com/blog/2015/10/27/javascript-single-thread-and-browser-event-loop/)中都曾提到了HTML5 Web Worker这一个概念。在[JavaScript单线程和浏览器事件循环简述](http://greengerong.com/blog/2015/10/27/javascript-single-thread-and-browser-event-loop/)中讲述了JavaScript出于界面元素访问安全的考虑，所以JavaScript运行时一直是被实现为单线程执行的；这也意味着我们应该尽量的避免在JavaScript中执行较长耗时的操作（如大量for循环的对象diff等）或者是长时间I/O阻塞的任务，特别是对于CPU计算密集型的操作。

例如在JavaScript中尝试计算像`fibonacci`这类计算密集型的操作，就会导致整个页面体验被blocked。HTML5 Web Worker的出现让我们在不阻塞当前JavaScript线程的情况下，在当前的JavaScript执行线程中可利用Worker这个类新开辟一个额外的线程来加载和运行特定的JavaScript文件，这个新的线程和JavaScript的主线程之间并不会互相影响和阻塞执行的；并且在Web Worker中提供这个新线程和JavaScript主线程之间数据交换的接口：postMessage和onMessage事件。它和C# WinForm中的BackgroundWorker很类似。

###Web Worker实现fibonacci计算

利用HTML5 Web Worker实现`fibonacci`可像如下所示（[plnkr在线demo](http://plnkr.co/edit/IoXkPw?p=preview)）：


fibonacci.js Worker JavaScript文件：

	(function() {
	  var fibonacci = function(n) {
	    return n < 2 ? 1 : (fibonacci(n - 1) + fibonacci(n - 2));
	  };

	  onmessage = function(event) {
	    postMessage({
	      input: event.data,
	      result: fibonacci(event.data)
	    });
	  };

	})();

在fibonacci.js中利用onmessage方法来监听主线程发送的fibonacci计算请求，和利用postMessage返回计算的结果到请求线程。

script.js 主线程JavaScript文件：

	$(function() {
	  var $input = $('#input'),
	    $btn = $('#btn'),
	    $result = $('#result'),
	    worker = new Worker('fibonacci.js'),
	    timeKey = function(val) {
	      return 'fibonacci(' + val + ')';
	    };

	  worker.onmessage = function(event) {
	    console.timeEnd(timeKey(event.data.input));
	    $result.text(event.data.result);
	  };

	  $btn.on('click', function() {
	    var val = parseInt($input.val(), 10);
	    if (val) {
	      console.time(timeKey(val));
	      $result.text('?')
	      worker.postMessage(val);
	    }
	  });
	});

在这个JavaScript文件中，利用`new Worker('fibonacci.js')`方式来创建Web Worker对象，并利用Worker对象上的postMessage方法发送请求计算请求，以及利用Worker对象的哦你message的方法接受Worker线程的返回结果，并显示在UI界面上。同时我们也利用了console最新的time API来统计计算所花费的时间。

其显示效果如下：

![html5 web worker demo](/images/blog_img/html5-web-worker-demo.png)

在console中打印的时间信息为：

	fibonacci(10): 1.022ms
	fibonacci(20): 1.384ms
	fibonacci(30): 22.065ms
	fibonacci(40): 1744.352ms
	fibonacci(50): 202140.027ms

从这里时间输出可以看出，在计算n为40的`fibonacci` 开始时间开始急速的加长，在UI中返回结果的时间也逐渐变长；但是在Web Worker后台计算的时候，它并不会阻塞我们的UI界面的其他交互。

###Web Worker总结

Web Worker在这类耗时计算密集型操作中，显得特别实用。在Web Worker中我们可以实现：

1. 可以加载一个JS进行大量的复杂计算而不挂起主进程，并通过postMessage，onmessage进行通信；
2. 可以在worker中通过importScripts(url)加载另外的脚本文件；
3. 可以使用 setTimeout()，clearTimeout()，setInterval()，clearInterval()；
4. 可以使用XMLHttpRequest来发送请求，以及访问navigator的部分属性。

但是它也存在一些来自浏览器`安全沙盒`的限制：

1. 不能加载跨域的JavaScript文件；
2. 如文件开始所说，考虑到JavaScript操作DOM的安全性问题，在Web Worker中不能访问界面中的DOM信息，对于DOM的访问操作都必须委托给JavaScript主线程来操作；因此HTML5 Web Worker的出现的出现，并没有改变JavaScript单线程执行的这个事实；
3. 还有就是Web Worker的浏览器兼容性问题。它的浏览器兼容性图如下：

![html5 web worker浏览器兼容性](/images/blog_img/html5-web-worker-浏览器兼容性.png)

更多关于Web Worker的资料，请参考[https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)。

