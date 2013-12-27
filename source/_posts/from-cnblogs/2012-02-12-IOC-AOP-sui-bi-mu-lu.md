---
layout: post
title: "IOC/AOP随笔目录"
description: "IOC/AOP随笔目录"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在当前软件开发OO设计中，面对软件需求的各种潜在变化，我们可能会采用领域驱动开发，把我们的各个业务逻辑分层次隔离解除耦合，这就出现了N层架构（这面值得是逻辑上的分层，当然我们的逻辑分层层次需要比物理架构层次多），这样将会使得我们的软件能够适应更多的需求变化。关于领域驱动开发的实例网上都很多，不得不推荐的是微软开源实例项目的NLayerApp：[http://microsoftnlayerapp.codeplex.com/](http://microsoftnlayerapp.codeplex.com/ "http://microsoftnlayerapp.codeplex.com/")。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 然而在于我们的逻辑分层的每一层次之间的耦合度解耦也是一个常见的问题.这样在层次的变化中我们需要实现不变更服务层次，这是我们的设计必须依赖于不变接口（抽象）。对于分层的接口对象创建我们当前流程的解决方案是IOC框架，负责不变对象的创建组合，当下流行的IOC框架有：[Autofac](http://code.google.com/p/autofac/)，[Castle Windsor](http://sourceforge.net/projects/castleproject/files/Windsor/2.5/Castle.Windsor.2.5.3.zip/download)，[Unity](http://entlib.codeplex.com/)，[Spring.NET](http://www.springframework.net/)，[StructureMap](http://sourceforge.net/projects/structuremap/files/)，[Ninject](http://ninject.org/download)，当然这么多IOC框架供我们选择。我本人只了解 [Castle Windsor](http://sourceforge.net/projects/castleproject/files/Windsor/2.5/Castle.Windsor.2.5.3.zip/download)，[Unity](http://entlib.codeplex.com/)，更喜欢[Unity](http://entlib.codeplex.com/)这套微软自身的轻量级ioc框架。关于IOC框架的测试园友[Leepy](http://home.cnblogs.com/u/liping13599168/)有测试[各大主流.Net的IOC框架性能测试比较](http://www.cnblogs.com/liping13599168/archive/2011/07/17/2108734.html)。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 另外我还想说的是我们的业务处理中有很多共性，并非业务本身的，比如权限，日志，缓存等功能模块，如果我们每次都重复将是一个巨大的工作量和难以维护的成本。应运而生的AOP框架，就是一种从业务纵向切入，对目标实现权限，日志等。对于AOP的实现主流框架主要有透明代理和静态植入两大类。Castle和EL中的PIAB就是一种透明代理的实现方式，PostSharp则是编译时静态注入框架。其他框架还有[SetPoint](http://setpoint.codehaus.org/Downloads)，[NAop](http://sourceforge.net/projects/aopnet/files)，[NKalore](http://aspectsharpcomp.sourceforge.net/download.htm)。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 今天整理一下本博客汇总关于IOC，AOP的随笔，忘大家不辞吝啬多多指教，共同进步。

一：IOC目录：

1.  IOC应用篇： 

    1.  [利用Attribute简化Unity框架IOC注入](http://www.cnblogs.com/whitewolf/archive/2011/11/29/2268379.html)
    2.  [AOP之PostSharp7-解决IOC 不能直接new问题，简化IOC开发和IOC对象LazyLoad](http://www.cnblogs.com/whitewolf/archive/2011/12/18/PostSharp7.html)
    3.  [WCF利用企业库Unity框架的IOC层次解耦](http://www.cnblogs.com/whitewolf/archive/2012/02/07/2342071.html)

二：AOP目录：

1.  AOP静态植入原理： 

    1.  [浅谈.NET编译时注入（C#&#8212;&gt;IL）](http://www.cnblogs.com/whitewolf/archive/2011/07/26/2117661.html)
    2.  [浅谈VS编译自定义编译任务&#8212;MSBuild Task(csproject)](http://www.cnblogs.com/whitewolf/archive/2011/07/27/2119005.html)
    3.  [编译时MSIL注入--实践Mono Cecil(1)](http://www.cnblogs.com/whitewolf/archive/2011/07/28/2119969.html)
    4.  [MSBuild + MSILInect实现编译时AOP之预览](http://www.cnblogs.com/whitewolf/archive/2011/08/09/2132217.html)
    5.  [MSBuild + MSILInect实现编译时AOP-改变前后对比](http://www.cnblogs.com/whitewolf/archive/2011/08/09/2133106.html)
2.  PostSharp AOP： 

    1.  [AOP之PostSharp初见-OnExceptionAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
    2.  [AOP之PostSharp2-OnMethodBoundaryAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
    3.  [AOP之PostSharp3-MethodInterceptionAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
    4.  [AOP之PostSharp4-实现类INotifyPropertyChanged植入](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
    5.  [AOP之PostSharp5-LocationInterceptionAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
    6.  [AOP之PostSharp6-EventInterceptionAspect(事件异步调用)](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
    7.  [AOP之PostSharp7-解决IOC 不能直接new问题，简化IOC开发和IOC对象LazyLoad](http://www.cnblogs.com/whitewolf/archive/2011/12/18/PostSharp7.html)
    8.  [PostSharp - Thread Dispatching（GUI多线程）](http://www.cnblogs.com/whitewolf/archive/2011/08/18/2144153.html)

&nbsp;&nbsp;&nbsp; 本系列中的随笔还有继续，我会不断更新。忘大家不辞吝啬多多指教，共同进步。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/02/12/2348521.html "原文首发")