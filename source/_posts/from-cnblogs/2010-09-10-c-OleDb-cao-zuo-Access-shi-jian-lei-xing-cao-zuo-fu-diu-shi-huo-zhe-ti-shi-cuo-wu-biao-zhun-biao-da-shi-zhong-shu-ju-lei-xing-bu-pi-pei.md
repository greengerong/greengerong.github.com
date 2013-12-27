---
layout: post
title: "c# OleDb操作Access时间类型：操作符丢失，或者提示错误“标准表达式中数据类型不匹配"
description: "c# OleDb操作Access时间类型：操作符丢失，或者提示错误“标准表达式中数据类型不匹配"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在c# OleDb操作Access时间类型的时候报错：操作符丢失，或者提示错误&#8220;标准表达式中数据类型不匹配&#8221;。

解决方案：

&nbsp;&nbsp;&nbsp;&nbsp; ASP.NET在操作日期型数据的时候,向ACCESS中的"时间/日期"字段中插入数据需要两边加#，而SQL SERVER不用。 这可能是C#中的日期类型无法直接转换成Access中的日期类型OleDbType.DBDate所致，因此上面代码向ACCESS中的"时间/日期"字段中插入DateTime.Now时出现错误信息&#8220;标准表达式中数据类型不匹配。&#8221; 

如代码：

	String Sql = "update  ly set re_message='" + TextBox1.Text + 	"',re_date=#" + DateTime.Now + "# where ID=" + page_id;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/09/10/1823524.html "原文首发")