---
layout: post
title: "混合模式程序集是针对“V2.050727”版本生成的，在没有配置信息情况下，无发在4.0运行时架子程序集。"
description: "混合模式程序集是针对“V2.050727”版本生成的，在没有配置信息情况下，无发在4.0运行时架子程序集。"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; 混合模式程序集是针对&#8220;V2.050727&#8221;版本生成的，在没有配置信息情况下，无法子啊4.0运行时架子程序集。

&nbsp;

![](http://images.cnblogs.com/cnblogs_com/whitewolf/MixedRUntime1.jpg)

&nbsp;&nbsp;&nbsp;我的做法是在文件中加如app.config，加入：

<font color="#ff0000">&nbsp;&lt;startup useLegacyV2RuntimeActivationPolicy="true"&gt; 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;supportedRuntime version="v4.0" /&gt;&nbsp;&nbsp;&nbsp; 
&nbsp; &lt;/startup&gt; </font>

&nbsp;参考原文：

Mixed mode assembly is built against version 'v2.0.50727' error using .NET 4 Development Web Server

If your application has a dependency on an assembly built in .NET 2 you will see the error below if you try to run your application when it has been built in.NET 4.

_**Mixed mode assembly is built against version 'v2.0.50727' of the runtime and cannot be loaded in the 4.0 runtime without additional configuration information.**_

This can be important in VS2010 testing, as test projects must be built as .NET 4, there is no option to build with an older runtime. I suffered this problem when trying to do some development where I hosted a [webpart that make calls into SharePoint (that was faked out with Typemock Isolator) inside a ASP.NET 4.0 test harness](http://blogs.blackmarble.co.uk/blogs/rfennell/archive/2010/03/25/a-fix-to-run-typemock-isolator-inside-the-page-load-for-an-aspx-page-on-vs2010-net4.aspx)

The answer to this problem is well documented, you need to add the **useLegacyV2RuntimeActivationPolicy** attribute to a .CONFIG file, but which one? It is not the **web.config** file you might suspect, but the **C:\Program Files (x86)\Common Files\microsoft shared\DevServer\10.0\WebDev.WebServer40.exe.config** file. The revised config file should read as follows (new bits in <font color="#ff0000">red</font>)

> &lt;?xml version="1.0" encoding="utf-8" ?&gt; 
> &lt;configuration&gt; 
> &nbsp;<font color="#ff0000"> &lt;startup useLegacyV2RuntimeActivationPolicy="true"&gt; 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;supportedRuntime version="v4.0" /&gt;&nbsp;&nbsp;&nbsp; 
> &nbsp; &lt;/startup&gt; </font>
> 
> &nbsp; &lt;runtime&gt; 
> &nbsp;&nbsp;&nbsp; &lt;generatePublisherEvidence enabled="false" /&gt; 
> &nbsp; &lt;/runtime&gt; 
> &lt;/configuration&gt;

Note: Don&#8217;t add the following _&lt;supportedRuntime version="v2.0.50727" /&gt;&nbsp; this cause the web server to crash on start-up. _

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/05/14/2046449.html "原文首发")