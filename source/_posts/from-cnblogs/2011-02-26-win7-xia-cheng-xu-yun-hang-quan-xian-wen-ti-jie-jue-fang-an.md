---
layout: post
title: "win7下程序运行权限问题解决方案"
description: "win7下程序运行权限问题解决方案"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 今天遇见一个win7下程序运行权限问题(需要对目录下文件有读写权限)：网上google下得到解决方案有,现记录下：

## 一：

&nbsp;&nbsp; windows 7和vista提高的系统的安全性，同时需要明确指定&#8220;以管理员身份运行&#8221;才可赋予被运行软件比较高级的权限，比如访问注册表等。否则，当以普通身份运行的程序需要访问较高级的系统资源时，将会抛出异常。 

　　如何让程序在启动时，自动要求&#8220;管理员&#8221;权限了，我们只需要修改app.manifest文件中的配置项即可。

　　app.manifest文件默认是不存在的，我们可以通过以下操作来自动添加该文件。

（1）进入项目属性页。

（2）选择&#8220;安全性&#8221;栏目。

（3）将&#8220;启用ClickOnce安全设置&#8221;勾选上。

　　现在，在Properties目录下就自动生成了app.manifest文件，打开该文件，将trustInfo/security/requestedPrivileges节点的requestedExecutionLevel的level的值修改为requireAdministrator即可。如下所示：

<div class="cnblogs_code" onclick="cnblogs_code_show('196faf80-6c73-421d-a3a0-d3e648f2ca9c')">
<div id="cnblogs_code_open_196faf80-6c73-421d-a3a0-d3e648f2ca9c">
<div><!--

Code highlighting produced by Actipro CodeHighlighter (freeware)

http://www.CodeHighlighter.com/

--><span style="color: #000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;</span><span style="color: #000000">requestedPrivileges&nbsp;xmlns</span><span style="color: #000000">=</span><span style="color: #800000">"</span><span style="color: #800000">urn:schemas-microsoft-com:asm.v3</span><span style="color: #800000">"</span><span style="color: #000000">&gt;</span><span style="color: #000000">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="color: #000000">&lt;</span><span style="color: #000000">requestedExecutionLevel&nbsp;level</span><span style="color: #000000">=</span><span style="color: #800000">"</span><span style="color: red">**requireAdministrator**</span><span style="color: #800000">"</span><span style="color: #000000">&nbsp;uiAccess</span><span style="color: #000000">=</span><span style="color: #800000">"</span><span style="color: #800000">false</span><span style="color: #800000">"</span><span style="color: #000000">&nbsp;</span><span style="color: #000000">/&gt;</span><span style="color: #000000">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #000000">&lt;/</span><span style="color: #000000">requestedPrivileges</span><span style="color: #000000">&gt;</span></div></div></div>

&nbsp;

　　记住，如果不需要ClickOnce，可以回到项目属性页将&#8220;启用ClickOnce安全设置&#8221;不勾选。&nbsp;　　

　　接下来，重新编译你的程序就OK了。

&nbsp;

## 二：

&nbsp; 可以把文件的安装路径默认在非系统目录下，如d:\sorftwarename\等。或者酱程序和读写数据分开，读写数据文件放在我的文档下等，避开文件访问读写权限，避开program files目录。像google德Chrome就是文件直接默认（不能改动）安装在AppData下。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/02/26/1965824.html "原文首发")