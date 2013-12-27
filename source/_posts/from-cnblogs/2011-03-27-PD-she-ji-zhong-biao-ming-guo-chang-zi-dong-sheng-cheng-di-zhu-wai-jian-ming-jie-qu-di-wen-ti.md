---
layout: post
title: "PD设计中表名过长，自动生成的主外键名截取的问题"
description: "PD设计中表名过长，自动生成的主外键名截取的问题"
category: cnblogs
tags: [code,cnblogs]
---
在PowerDesinger中，若表名过长，自动生成的主键名会被自动截取。

解决如下：DataBase/Edit Current DBMS/Scripts/Objects/PKey/ConstName中找到Value的值，
默认是 <span style="color: red">PK_%.U27:TABLE%</span>，<span style="color: red">U27</span>表示截取27个字符。改成PK_%TABLE%主键名就不会被截取了。

其他键同理：找到相应的ConstName Value去掉U.\d:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/03/27/1996786.html "原文首发")