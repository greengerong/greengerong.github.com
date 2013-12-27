---
layout: post
title: "表现层模式-MVC"
description: "表现层模式-MVC"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在前面简述了从服务层到数据层参见[架构设计目录](http://www.cnblogs.com/whitewolf/archive/2012/06/06/2537593.html)。剩下了表现层，一个再好的中间层表现也必须有一个用户界面，提供和用户交互，将用户行为输入转化为系统操作，进入后台逻辑。在当下RAD（快速应用开发）工具的支持下，我们可以比较快速的完成UI设计，RAD追求所见即所得的快速反馈，快速应用。表现层也有一定其固定的逻辑（格式化，数据绑定，转化等等，称为UI逻辑）和界面展现。这里UI逻辑指的是所有用来处理数据显示在UI界面的逻辑和，将UI用户输入行为转化为中间层指令的逻辑，负责UI和中间层数据流和行为的转化。很多时候UI是最容易变化的以及最不易测试的逻辑（我一直相信，1：一段好的代码一定要易于测试。2：重构的前提也必须有足够的测试保证，才能让我们的重构更有节奏更自信），而很大部分UI逻辑却往往比较稳定的。这Matin Fowler提出的分离表现层模式。表现层模式主要分为3种大类：MVC，MVP，PM（微软在sl和wpf起名为MVVM），这3类模式下延伸了很多变异体mvc在web的 model2（asp.net mvc，主要特征基于web特有uri路由）。mvp的变种：Passive View（被动视图）和Supervising Controller（不清楚怎么翻译比较好），PM延伸MVVM。其目的都在于将多变的View和UI逻辑分离。

&nbsp;&nbsp;&nbsp;&nbsp; 今天要说的是MVC（model-view-controller：模型-视图-控制器）。在我们一开始就说结构和编程或者[面向对象原则](http://www.cnblogs.com/whitewolf/archive/2012/05/08/2489425.html)都是为了实现模块的高内聚低耦合，而高内聚低耦合行之有效的方式就是分离关注点（SOC）。为了实现表现UI和表现逻辑的分离，使得他们之间更灵活，并且自治视图(包含所有表现层代码的类)。在30年前[Trygve Reenskaug](http://zh.wikipedia.org/w/index.php?title=Trygve_Reenskaug&amp;action=edit&amp;redlink=1 "Trygve_Reenskaug&amp;action=edit&amp;redlink=1")提出的[MVC模式](http://zh.wikipedia.org/wiki/MVC)，或者更确切的说模范。其将表现层分为3类：model：是视图展现数据，view用户交互界面，Controller：将用户输入转化为中间层操作。

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201207/20120707145514741.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201207/201207071455125856.png)

&nbsp;&nbsp;&nbsp; 模型（Model）：在MVC中模型保持着一个应用程序的状态，和相应视图中来自用户交互的状态变化。在上图中我们可以看到model会接受来之控制器的状态变化响应和视图的显示状态查询view渲染的数据来源。同时model还有通过事件机制（观察者模式）通知view状态的改变要求view渲染响应。view和模型之间存在一定的耦合，view必须了解model，这也是MVP模式出现原因之一。正在这里的模型model可以是来之分布式soap或者resetfull的dto（数据传输对象），也可以直接是我们的领域对象（do）或者数据层返回的数据集，并不严格的 要求。

&nbsp;&nbsp; 控制器（Controller）：控制器是又view触发，响应用户界面的交互，并根据表现层逻辑改变model状态，以及中间层的交互，最终修改model，Controller不会关心视图的渲染，是通过修改model，model的事件通知机制，触发view的刷新渲染。控制器和模型的交互式一种&#8220;发出即忘&#8221;，或者分布式OneWay的调用。控制器Controller不会主动了了解view和view交互，除了唯一的视图选择外，控制器需要选择下一次显示的视图view是什么。一般控制器会请求全局应用程序路由下一个需要显示的view，在使其呈现出来。

视图（View）：视图时表现层模式出现的原因，因为他的多样性和变化的频繁性，不易测试（太多外界环境依赖），所以理想的视图应该尽可能的哑，被动，视图只负责渲染呈现给用户交互。视图由一些列GUI组件组成，响应用户行为触发控制器逻辑，修改model状态使其保持view同步。视图并需要相应model的变化被动的接受model状态变化刷新相应给用户。

&nbsp;&nbsp; MVC最先兴起于桌面，但没有流行起来，知道在web兴起后，其变异体Model2在Web中流行起来，.net 下的ASP.NTE MVC。Model2中，将来自客户端（浏览器）的请求，被服务端拦截器（asp.net中HttpModule）根据url格式请求方式等转发到固定的控制器，调用固定的Action，在Action中队模型状态进行修改，并选择view，view并根据控制器传来的最新model生产html，css，js前段代码，并输出到前段渲染。

&nbsp; 在Model2中和原始MVC最大的差别在于:

1：视图view和模型model之间没有直接依赖，model并不知道view也不需要事件通知view，view也不需知道model，view操作的都是ViewModel（asp.net mvc 中ViewData容器）。2：控制器显示传入视图数据给view，相应用户的操作不是来自view，而是出于服务端应用程序前段的拦截器，捕获url并转发到相应的控制器，已经调用相应的action方法。

&nbsp; 在现在说的MVC往往指的就是Web中Model2模式。在Model2中view是被动的，哑的，简单。

&nbsp;

![](http://images.cnblogs.com/cnblogs_com/whitewolf/未命名.png)

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/07/07/2580630.html "原文首发")