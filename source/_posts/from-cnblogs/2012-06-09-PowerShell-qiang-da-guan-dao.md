---
layout: post
title: "PowerShell强大管道"
description: "PowerShell强大管道"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; PowerShell是在Window是的外壳语言，提供了多Windows的更多操作，让我们于windows的操作更简单方便，以及就是就是管理员的命令行更好的管理。PowerShell提供了与.net FCL（.net类库）的操作性，我们可以利用强大的.net FCL在PowerShell中。PowerShell提供强大的管道模型，管道指的是一个命令的输出可以利用操作符（|）方便的传递到下个命令作为输入。PowerShell不同传统管道模型的是它是一门基于对象的管道流，即在命令之间传递的对象不是简单的文本。下面我们就以本地文件操作来实践PowerShell的管道常见命令：

&nbsp;&nbsp;&nbsp; 1：集合遍历ForEach-Object：可以简写为foreach，或者%代替，提供了管道传入的对集合的遍历，同时提供了操作前begin，操作process，结束end命令，其中$_提供对当前索引的指代。

&nbsp; 示例：下面我们实践利用ForEach-Object来计算本地文件目录的文件大小：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/20120609153154315.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091531544186.png) 

&nbsp;&nbsp;&nbsp; 2：条件选择Where-Object：可以简写为where或者？代替。提供了对管道输入集合的过滤筛选，类似于SQL中的where条件，$_提供对当前索引的指代。

&nbsp;&nbsp; 示例：输出文件大于100KB的文件名字和大小：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/20120609153159287.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091531563054.png) 

&nbsp;&nbsp; 3：选择Select-Object：简写select，提供了对对象的选择类似于sql的select，.net的new匿名对象。同时select支持-first和-last取最前面或者最后面的几个相当于sql 中top，与下例中Sort-Object结合将很有用。

&nbsp; 示例：选择目录下文件的文件名和大小输出：

[![SNAGHTML3b707d0](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/20120609153202584.png "SNAGHTML3b707d0")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532005959.png)

&nbsp;&nbsp; 4：排序Sort-Object：简写sort，对于集合对象参照一个或者多个属性排序，可以指定-descending为倒序。

&nbsp;&nbsp;&nbsp;&nbsp; 示例：获取最大的前5个文件：

[![SNAGHTML3bc4128](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532053422.png "SNAGHTML3bc4128")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532038731.png)

&nbsp;&nbsp; 5：管道树Tee-Object：简写为tee，可以把管道模型传入的对象记录在文件日志或者赋值给变量保存等。提供-inputObject ，-filePath ，-variable 

&nbsp; 示例：保存文件对象时$test变量：

[![SNAGHTML3c03d8f](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532075638.png "SNAGHTML3c03d8f")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532061570.png)

&nbsp;&nbsp;&nbsp; 6：分组Group-Object：简写group，提供依据属性分组类似sql group by。

&nbsp;&nbsp; 示例：按照文件类型分组并按照组内文件个数排序
 [![SNAGHTML3c30688](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532092772.png "SNAGHTML3c30688")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532082149.png)  

&nbsp;

&nbsp;

&nbsp;&nbsp; 7：集合统计Measure-Object：简写：measure，提供了对集合的统计，简便的方法来获取最小值、最大值及平均值属性。

&nbsp; 示例：统计文件大小的最小值，最大值，平均值，总大小：

[![SNAGHTML3c60aad](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532117920.png "SNAGHTML3c60aad")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532109524.png)

&nbsp;&nbsp; 8：比较Compare-Object：简写diff，提供了对两个对象或集合的比较，其中有单侧指向器，=&gt;表达此对象出现在右边，&lt;=表示差异对象存在于左边。

&nbsp;&nbsp;&nbsp;&nbsp; 示例：新建一个文件夹2，比较连个目录的不同：

[![SNAGHTML3cb035d](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532124215.png "SNAGHTML3cb035d")](http://images.cnblogs.com/cnblogs_com/whitewolf/201206/201206091532123592.png)

今天就到这里，PowerShell很强大，继续学习。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/06/09/2543247.html "原文首发")