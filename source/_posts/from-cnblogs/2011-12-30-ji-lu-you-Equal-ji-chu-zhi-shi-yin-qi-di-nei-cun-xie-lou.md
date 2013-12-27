---
layout: post
title: "记录由Equal基础知识引起的内存泄露"
description: "记录由Equal基础知识引起的内存泄露"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在最近的公司框架开发中，利用了网上某大牛的反射缓存库作为辅助。在测试的时候发现出现了巨大的内存泄露，在频繁的操作后，内存不断的产生巨大的开销，10多分钟就占有了5,6m的内存。解决问题的时，公司不能上网，没有内存分析工具，没有我钟爱的ANTS Memory Profiler帮助下，我们只能靠简单的内存输出来二分查找缩小范围，利用

[System.Diagnostics](http://msdn.microsoft.com/zh-cn/library/system.diagnostics.aspx)命名空间下的Process的WorkingSet64属性来统计两次输出的内存增长量（WorkingSet64：描述关联的进程分配的物理内存量（以字节为单位））。花了半天终于定位到了第三方的缓存块，一看吓一跳居然缓存了2,3万的对象。看到这里我很清楚的猜测到自定义缓存key一定没有重写来自Object的Equal方法，在三两下很快解决了这次问题。哎，本不该相信第三方，刚开始还以为我数据绑定注册的一大堆客户端控件的事件引起的，但是我实现了IDisposable并取消了事件的，必究事件代理是强类型引用。

&nbsp;&nbsp;&nbsp; 在这里我简单说说这个本是基础知识的东西。说道Equal，我们会联想到==操作符，==对于值类型表示的是值相等，除string类型（内部重写）外表示的是对象的引用，同一个引用地址才会相等。Equal描述的是对象的内容是否相等。但是在Object中默认实现是对引用reference的比较，我们要实现值的比较这必须重写Equal方法和GetHashCode方法，这两个是同时重写的。在我们的IList.Contains，IDictionary.Contains中利用对象的比较就是默认的Equal方法比较，所以我们必须重写这个方法，来达到我们实际的值比较。[MSDN：Equals() 和运算符 == 的重写准则（C# 编程指南）](http://msdn.microsoft.com/zh-cn/library/ms173147(v=vs.90).aspx)

&nbsp;&nbsp; 然而在我们3.0后的表达式linq中对于对象的比较，我们需要实现的IEqualityComparer&lt;T&gt;接口，如下定义：

public static bool Contains&lt;TSource&gt;(this IEnumerable&lt;TSource&gt; source, TSource value, IEqualityComparer&lt;TSource&gt; comparer);

在微软内部实现了5个重要的类，如下图（图来自博客园鹤冲天大牛）：

[![image](http://images.cnblogs.com/cnblogs_com/ldp615/201108/201108012131253311.png "image")](http://images.cnblogs.com/cnblogs_com/ldp615/201108/201108012131243444.png)

在这里我不想在说很多，关于可以参见博客园鹤冲天大牛的[c# 扩展方法奇思妙用基础篇八：Distinct 扩展](http://www.cnblogs.com/ldp615/archive/2011/08/01/distinct-entension.html)，[何止 Linq 的 Distinct 不给力](http://www.cnblogs.com/ldp615/archive/2011/08/02/2125112.html)文章实战。

最后给初学者提醒一句，对于IList.Contains，IDictionary.Contains注意实现Equal和GetHashCode，Linq比较IEqualityComparer&lt;TSource&gt;。

本不该错的，应该是大牛忘写了吧，可是害惨了我。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/30/2307894.html "原文首发")