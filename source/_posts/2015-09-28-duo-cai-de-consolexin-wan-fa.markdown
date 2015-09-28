---
layout: post
title: "多彩的Console新玩法"
date: 2015-09-28 08:53:40 +0800
comments: true
categories: [chrome]
---
Chrome应该是每一个Web开发者必备的工具之一。它有而强大的Devtool，辅助我们的JavaScript调试，审视DOM元素，CSS即时修改等。以及它还有一个的庞大的插件系统，同时我们也可以很容易的扩展属于自己的Chrome插件。如果希望了解更多的Chrome常用调试，请参见笔者早期的微信推送文章[《15个必须知道的chrome开发者技巧》](http://mp.weixin.qq.com/s?__biz=MjM5NTM1NDcyOQ==&mid=204026297&idx=1&sn=47294644cc7298ea3c57736ed0a75173&scene=23&srcid=0928aP9a3QHDyTOtc2Nhrszw#rd)。

Chrome中的控制台console，是我们检查程序允许是否正常的常用工具之一，同时它也是我们打印调试日志信息，运行调试代码的常用工具。在国内近几年，它也成为了程序员招聘的渠道之一。如下面百度的招聘信息：

![百度console招聘](/images/blog_img/baidu-console-recruitment.png)

在Console中打印日志的方式有log、info、warn、error这几类方式。但它们并不是今天的主题。对于日志信息打印来说，一直都显得很单调。直到最新版的Chrome和Firefox (+31)后，我们可以尝试更多多彩的打印样式了。在最新的Google chrome文档中console.log支持如下的格式：

1. %s	字符串格式化；
2. %d/%i	整数格式化；
3. %f	小数位数据格式化；
4. %o	可扩展的DOM节点格式化；
5. %O	可扩展的JavaScript对象格式化；
6. %c	利用CSS来自定义样式格式化输出。

当然我们今天要说的是%c这类格式化。我们可以利用CSS样式来控制打印信息的输出。这样我们就可以得到一个多彩的日志信息，或者就是招聘广告了。

下面代码输出效果为：

	console.log('%c [破狼]-[双狼说]!', 'background: #008000; color: #fff');


![彩色的console log](/images/blog_img/console-log-po-lang.png)

下面是一段来自http://stackoverflow.com/questions/7505623/colors-in-javascript-console的一段：文字光影的效果：

代码比较长，请移步到stackoverflow查看。这里主要是利用的text-shadow这个CSS3特性来实现的，文字光影效果：

	var css = "text-shadow: -1px -1px hsl(0,100%,50%), 1px 1px hsl(5.4, 100%, 50%), 3px 2px hsl(10.8, 100%, 50%), .....";// 

	console.log("%cExample %s", css, 'all code runs happy');

效果如下：

![彩色的console log](/images/blog_img/console-log-demo-colorful-code.jpg)

在github也有[log](https://github.com/adamschwartz/log)的repo，感兴趣的读者也可以研究研究。