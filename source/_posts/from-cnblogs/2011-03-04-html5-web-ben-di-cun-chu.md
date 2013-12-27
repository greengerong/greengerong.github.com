---
layout: post
title: "html5-web本地存储"
description: "html5-web本地存储"
category: cnblogs
tags: [code,cnblogs]
---
> &nbsp;&nbsp; 在html5中为我们提供了一种本地缓存机制，它将取代我们的cookie，并且它是不会随浏览器发会我们的服务器端的。我们可以采用js在客户端自由的操作本地缓存。html5中缓存主要有localStorage，和sessionStorage。他们的用法一致。区别在于他们的时间限制不同。localStorage是不存在时间限制的。而sessionStorage这时基于session的数据存储，在关闭或者离开网站后，数据将会被删除。
> 
> &nbsp; 下面我们来简单看看官方的示例操作：
> 
> **javascript**
> 
> localStorage.fresh = &#8220;vfresh.org&#8221;;&nbsp;&nbsp; //设置一个键值 
> var a = localStorage.fresh;&nbsp;&nbsp; //获取键值
> 
> 或者使用它的API： 
> **javascript**
> 
> //清空storage 
> localStorage.clear();
> 
> //设置一个键值 
> localStorage.setItem(&#8220;fresh&#8221;,&#8220;vfresh.org&#8221;);
> 
> //获取一个键值 
> localStorage.getItem(&#8220;fresh&#8221;);&nbsp; 
> 
> //return &#8220;vfresh.org&#8221; //获取指定下标的键的名称（如同Array） 
> localStorage.key(0);&nbsp; 
> 
> //return &#8220;fresh&#8221; //删除一个键值 
> localStorage.removeItem(&#8220;fresh&#8221;);
> 
> &nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sessionStorage相同就不用在废话了，他相当于我们的过期时间Expire=0的cookie；

&nbsp;



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/03/04/1970457.html "原文首发")