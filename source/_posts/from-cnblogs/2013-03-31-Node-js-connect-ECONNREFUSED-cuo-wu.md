---
layout: post
title: "Node.js connect ECONNREFUSED错误"
description: "Node.js connect ECONNREFUSED错误"
category: cnblogs
tags: [code,cnblogs]
---
   最近在准备Angularjs +node.js demo的时候在我的mac开发中 遇见此错误，如下：    

	events.js:71
    	    throw arguments[1]; // Unhandled 'error' event
                       ^
	Error: connect ECONNREFUSED
    	at errnoException (net.js:770:11)
   	 at Object.afterConnect [as oncomplete] (net.js:761:19)
 
最后在stackoverflow找到解决方案，这主要由于上一次node.js server进程仍然还在运行没关闭掉，所以我们需要杀掉此进程，在mac上操作为：
 
	ps aux | grep node
 
	twer    7668  4.3  1.0  42060 10708 pts/1    Sl+  20:36   0:00 
	node server 
	twer    7749  0.0  0.0   4384   832 pts/8    S+   20:37   0:00 
	grep --color=auto node
从输出可以看见进程PID7668在使用，所以我们必须杀掉这顽固分子，运行kill -9 7668. Ok，一键搞定，可以重新开启server了。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/03/31/2991588.html "原文首发")