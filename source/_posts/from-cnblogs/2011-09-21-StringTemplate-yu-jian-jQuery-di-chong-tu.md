---
layout: post
title: "StringTemplate遇见jQuery的冲突"
description: "StringTemplate遇见jQuery的冲突"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; &nbsp;最近在做一个流程引擎，现着手于自定义模板的处理。设计在模板中所有的数据都将与字段对应，采用xml结构序列化作为流程持久化机制。字段对于用户的输入则为字段，字段涉及到用户的输入，必定是控件。由于有以前项目word模板转化为在线展示输入经验（这里不仅仅是将word转化为html，还需要提取word书签作为关键字段，关键字段作为用户的输入，根据用户配置转化为文本框，下拉框，数字，货币框，时间等等可扩展控件）。我在本次的模板设计中不再考虑服务器控件，因为服务器控件将生成一大堆难以控制的html标记。所以彻底疯狂了一把，采用完全html+jQuery实现（验证用的也是jQuery validator）。关于流程的设计将会在后续慢慢总结。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;今天只是记录一下在控件用户设置界面字段修改界面需要还原用户的上次记录，因为我的全是html+jQuery，所以在框架设计中提供了两种方案：1：根据page对象注册页面初始化脚本，回填控件值。2：利用StringTemplate生成带有回填值的html输出。

&nbsp;&nbsp;&nbsp; 就是第二种方案的使用，出现了StringTemplate对于jQuery$的错误解析：解决方案总结如下：

1.  从jQuery触发，可以利用jQuery()代替$()。
2.  StringTemplate这可以使jQuery的$转义：\$.

&nbsp;&nbsp;&nbsp; 内容很少，废话很多，网见谅。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/09/21/2184488.html "原文首发")