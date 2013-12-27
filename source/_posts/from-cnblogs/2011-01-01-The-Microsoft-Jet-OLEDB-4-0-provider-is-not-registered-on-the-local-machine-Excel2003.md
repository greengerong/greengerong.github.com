---
layout: post
title: "The &#x27;Microsoft.Jet.OLEDB.4.0&#x27; provider is not registered on the local machine-Excel2003"
description: "The &#x27;Microsoft.Jet.OLEDB.4.0&#x27; provider is not registered on the local machine-Excel2003"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 今天在操作Excel2003时候在我的win7英文操作系统发生错误，（在此记录下来）：

The 'Microsoft.Jet.OLEDB.4.0' provider is not registered on the local machine.

在网上google了一下，错误原因是我的机子是64编译的，需要改为32位，在vs中设置将编译Any CPU改为x86，就ok。

![The ](http://images.cnblogs.com/cnblogs_com/whitewolf/QQ截图未命名.png)

&nbsp;

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/01/01/1923744.html "原文首发")