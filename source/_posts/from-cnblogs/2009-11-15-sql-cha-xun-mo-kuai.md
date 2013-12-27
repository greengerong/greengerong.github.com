---
layout: post
title: "sql 查询模块"
description: "sql 查询模块"
category: cnblogs
tags: [sql,cnblogs]
---
 已经好久没弄博客了，觉得该写些了。但是没想到写些什么，很多东西院子已经很多了。就把我最近在项目中的一个模块：SQL查询语句生成
 本模块实现了SQL查询的join（inner，left，right），where 条件（加入where条件出函数外的功能。本来函数功能也些出来了，就是我的指导老师说我们的项目对这个需求不大，还有对聚合函数支持不好，所以去掉了这个功能），支持查询表操作，多项排序。由于项目的实际需Group by 语句只提供聚合函数等简单功能和CUBE、ROLLUP。


不多说了，还是直接拿出来晒晒图。
![](http://images.cnblogs.com/cnblogs_com/whitewolf/1.JPG)


Sql视图


![](http://images.cnblogs.com/cnblogs_com/whitewolf/2.jpg)


结果验证视图：



![](http://images.cnblogs.com/cnblogs_com/whitewolf/41.JPG)&nbsp; 

Group by 设置界面

![](http://images.cnblogs.com/cnblogs_com/whitewolf/51.jpg)


图片就先放这样，还有些以后有机会在放。


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/15/1603288.html "原文首发")