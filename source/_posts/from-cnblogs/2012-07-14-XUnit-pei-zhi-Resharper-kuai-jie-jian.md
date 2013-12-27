---
layout: post
title: "XUnit配置Resharper快捷键"
description: "XUnit配置Resharper快捷键"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Resharper是一款很优秀的重构工具，已经习惯了Resharper快捷键，利用Resharper做重构，TDD开发，很爽。唯一缺点就是低配置机器上速度很慢，容易拖死VS，

为此我我专门把我的本本换成6G内存，现在感觉顺畅多了。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 回到正题，我在项目中运用了XUnit，但是VS和Resharper对其快捷键都还不能默认支持，所以在网上找到扩展Resharper使其支持Xunit，步骤如下：

1.  关闭所有VS。
2.  在[http://xunitcontrib.codeplex.com/](http://xunitcontrib.codeplex.com/ "http://xunitcontrib.codeplex.com/")下载xUnit.net Contrib
3.  把目录中的xunitcontrib.runner.resharper.Resharper版本号拷贝到C:\Program Files\JetBrains\ReSharper\Resharper版本号\bin\plugins 下（其中的plugins可能需要手动建立）。同样你也可以拷贝到&lt;RoamingAppData&gt;\JetBrains\ReSharper\Resharper版本号\vs版本号\plugins
4.  拷贝resharper.external.annotations\xunit.xml到C:\Program Files\JetBrains\ReSharper\Resharper版本号\bin\ExternalAnnotations目录下。
5.  开启VS。
 6.  ReSharper -&gt; Live Templates -&gt;"Import" 导入xunit-ae.xml或者xunit-xe.xml。xunit-xe.xml和xunit-ae.xml对XUnit断言语句的扩展简化，xunit-xe.xml以x开头，比如xe =&gt; Assert.Equal，而xunit-ae.xml则以a开头，比如ae =&gt; Assert.Equal。  

&nbsp;&nbsp; 最后大功告成。

更多信息参见[http://xunitcontrib.codeplex.com/](http://xunitcontrib.codeplex.com/ "http://xunitcontrib.codeplex.com/")。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/07/14/2591904.html "原文首发")