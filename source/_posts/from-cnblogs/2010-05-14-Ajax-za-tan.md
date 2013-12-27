---
layout: post
title: "Ajax杂谈"
description: "Ajax杂谈"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Google Suggest 和Google Map的出现，引起了我们Web开发者的一次震动。随着Ajax技术的出现、盛行，本被忽视认为是二流编程语言的JavaScript脚本也开始了新的盛行，大量的JavaScript框架的出现如Microsoft Asp.Net Ajax、jQuery等。Ajax已经成为这些脚本框架必不可少的组成部分了，而且Ajax的开发也越来越简单化。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ajax是一种已不是加载脚本，其最古老的实现方式是利用iframe来加载远程的脚本利用top.Function来调用父窗体的方法。利用a等HTML的target属性来指定。简单但是后期维护复杂化了并且在跨越方面很麻烦。接着就XMLHttpRequest对象的出现，一定程度的简化了Ajax的开发，但是在不同的浏览器中实现有很多大不同，FireFox中XMLHttpRequest和IE中的ActiveObject等方式，以及它仅提供了很少和简单的Ajax请求和处理。在现在出现了很多的JavaScript框架，在基于XMLHttpRequest的封装和类库的提供，极大的简化了我们的Ajax编程。其中最为出名和盛行的jQuery框架。这里需说出的是jQuery一定程度的实现了部分跨域问题。

下面我就说几点自己目前想到的Ajax注意或者技巧，思维也许有点乱，请谅解，将的不好，也请原谅。

&nbsp;&nbsp;&nbsp;&nbsp; 1：Ajax中的X是XML，它也可以很方便的加载XML，但是并不是说XML就是说XML就是Ajax的首选。首先大家都知道XML是一种严格的数据存储方式，有很多冗余信息。再则XML的处理也有一定的复杂性。XML能实现跨平台性，如WebService，这是WebService的优点，但是也是一个致命的缺点，它基于的XML冗余信息，所以在分布式中速度也是很慢的。

&nbsp;&nbsp;&nbsp; 相比而言Json对象是一个轻量级的存储方式，它是以名值对的形式存储。而且JavaScript脚本本身就是一个天然的Json对象，无需转化，可以直接使用，并且现在.NET框架中提供了对Json序列化的支持.我个人观点是首选Json。

&nbsp;&nbsp;&nbsp; 2：在服务器端为了性能等的考虑经常会有缓存，以及浏览器的缓存。有时我们需要避免，最简单的方式是加上一个时间戳，"Default.aspx?time=&#8221; + DateTime.Now。就可以避免缓存。如果你用的是Jquery的Ajax那可以直接设置cache:false禁用缓存。

&nbsp;&nbsp;&nbsp; 3：在Ajax编程需要注意的是**Content-Type**，有HTML、Text、Json、XML、Script等方式。我们很多的无故的错误经常就在这里的设置。需要注意Ajax的Content-Type，以及服务端输出的Content-Type。还有就是服务器端，我们要输出前的Response.Clear(),Response.ContentType=Type,以及完成时的Response.Flush()和Response.Clos（）。

&nbsp;&nbsp;&nbsp; 4：Ajax并不是高交互、高用户体验的代表，这需要说明。我们的应用不应该什么地方都用Ajax技术，使得Ajax技术在项目里泛滥，如果我们要用Ajax，那我们就必须为客户准备退路，因为ajax请求很可以由于各种原因而请求失败。

&nbsp;&nbsp; 5：Ajax必究是基于客户端脚本，这就意味在存在一定的安全隐患，很容易暴露我们的某些敏感信息。特别是网上的脚本代码糜烂，我们有些人经常会在网上Copy下来仅小小仅测试下就加入了我们的项目，这是一个很不好的习惯。很容易得不偿失。

&nbsp;&nbsp; 时间已晚，就说这么多吧，如果你还有什么心得或建议请留言。。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/05/14/1735119.html "原文首发")