---
layout: post
title: "CodeSmith模板引擎系列-目录"
description: "CodeSmith模板引擎系列-目录"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CodeSmith是一个基于模板的代码生成器，它可以生成任何基于ASCII的编程语言代码。生成的代码可以使用属性进行定制。属性可以是任何具有设计器的.NET对象（大多数.NET内置类型已经有设计器），也可以是一个允许你从结果中有条件地添加或移除代码的简单的boolean 属性，或是一个对象，例如能够访问数据库表信息的TableSchema对象（包括在SchemaExplorer中）。CodeSmith完全可扩展，它允许用户创建定制属性类型。CodeSmith中包括多个定制属性类型的例子，例如，定制一个允许选择XML文件（使用XmlSerializer可将其反序列化到对象中）的属性类型。CodeSmith还允许用户在模板中引用和调用指定的外部程序集并且允许从外部程序集的类生成模板。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CodeSmith的语法与ASP.NET几乎相同。因此如果你熟悉ASP.NET ，那么应该会很快理解模板语法。你可以在模板中使用C#、VB.NET或JScript.NET语言，并且模板可以输出任何基于ASCII的语言。CodeSmith还包括一个名为SchemaExplorer的程序集，利用它可以访问几乎所有的数据库概要（schema）细节。访问这种信息让你能够生成各种代码，例如存储过程、类型DataSet、业务对象、表示层代码或任何其它基于数据库概要信息的代码。（来自:[http://msdn.microsoft.com/msdnmag/issues/04/07/MustHaveTools/default.aspx](http://msdn.microsoft.com/msdnmag/issues/04/07/MustHaveTools/default.aspx)）

1.  [CodeSmith模板引擎系列一](http://www.cnblogs.com/whitewolf/archive/2010/07/13/1776379.html)
2.  [CodeSmith模板引擎系列二--文件目录树](http://www.cnblogs.com/whitewolf/archive/2010/07/14/1777088.html)
3.  [通过代码生成机制实现强类型编程-CodeSimth版](http://www.cnblogs.com/whitewolf/archive/2010/09/25/CodeSimthNamedCMessage.html)
4.  [<font color="#6699cc">Dbml文件提取建表TSql-CodeSmith</font>](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836731.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 打算写一些代码生成编译技术的系列，包括[CodeDom（CodeDom的代码生成技术目录](http://www.cnblogs.com/whitewolf/archive/2010/07/09/1774279.html)），[CodeSmith模板](#)、T4模板、StringTemplate,以及Expression Tree的系列随笔。如果可能的话再加上Emit系列。欢迎大家多多指教和交流。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836729.html "原文首发")