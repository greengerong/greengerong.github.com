---
layout: post
title: "去掉VS顽固Add-in"
description: "去掉VS顽固Add-in"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;卸掉VS Add-in的方法可以参考：

[Deactivate and Remove an Add-in](http://msdn.microsoft.com/en-us/library/ms228765.aspx) 
[How to get rid of a Visual Studio add-in](http://www.mztools.com/articles/2006/MZ2006018.aspx)

其中有两个比较简单易行的方法。

1）使用devenv命令

devenv.exe /resetaddin &lt;Namespace.Class&gt;

Namespace.Class即Add-In的实现类的完全限定名称，比如那个默认的Connect。对于我们开发的Add-In来说，可以查看.Addin文件中的&lt;FullClassName&gt;&lt;/FullClassName&gt;节点。

2）使用工具栏的自定义功能

我们可以把命令添加到工具栏，这也包括自定义的Add-In命令，方法是Tools-&gt;Customize&#8230;：

[![customize-commands](http://images.cnblogs.com/cnblogs_com/anderslly/WindowsLiveWriter/VSAddIn_148C5/customize-commands_thumb.jpg "customize-commands")](http://images.cnblogs.com/cnblogs_com/anderslly/WindowsLiveWriter/VSAddIn_148C5/customize-commands_2.jpg) 

将需要移除的命令拖到工具栏上，关闭对话框。如果Add-In已经卸载了，那么它的功能自然是不可用的了，此时点击工具栏的相应按钮，VS就会报错，此时就可以选择将其移除了。

转自：[一个程序员的自省](http://www.cnblogs.com/anderslly/archive/2009/05/28/remove-vs-addin-menu.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/07/14/1777357.html "原文首发")