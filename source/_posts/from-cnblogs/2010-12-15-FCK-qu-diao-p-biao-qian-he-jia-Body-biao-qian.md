---
layout: post
title: "FCK去掉p标签 和加Body标签"
description: "FCK去掉p标签 和加Body标签"
category: cnblogs
tags: [code,cnblogs]
---
如果您需要编辑模板页，默认的FCK设置是会去掉&lt;HTML&gt;&lt;/HTML&gt;&lt;BODY&gt;

&lt;/BODY&gt;标签，而且会给你加上&lt;P&gt;&lt;/P&gt;标签的，怎么办呢，只要设置一个小的

地方就可以了。在fckconfig里面有 FCKConfig.FullPage = false ;
改为 FCKConfig.FullPage = true
如果想去掉自动添加&lt;P&gt;的代码就可以在这里设置
默认是

	FCKConfig.EnterMode = 'p' ;   // p | div | br
	FCKConfig.ShiftEnterMode = 'br' ; // p | div | br

改成
	
	FCKConfig.EnterMode = '' ;   // p | div | br
	FCKConfig.ShiftEnterMode = 'br' ; // p | div | br	
		
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/12/15/1906959.html "原文首发")