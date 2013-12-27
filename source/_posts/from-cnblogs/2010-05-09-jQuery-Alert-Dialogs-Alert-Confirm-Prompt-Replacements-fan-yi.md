---
layout: post
title: "jQuery Alert Dialogs (Alert, Confirm, &amp; Prompt Replacements)(翻译)"
description: "jQuery Alert Dialogs (Alert, Confirm, &amp; Prompt Replacements)(翻译)"
category: cnblogs
tags: [code,cnblogs]
---


 前不久在官方网站是看见这个插件，所以今天趁有空就看了一下，随便给大家共享一下。也许你早已知道了，如果是这样那请跳过，不要拍砖。
 
 这个Jquery插件的目的是替代JavaScript的标准函数alert()，confirm（）<samp>，和 prompt（）。这个插件有</samp>
 
 <samp>如下这些特点：</samp>
 
 <samp>&nbsp; 1：这个插件可以使你可以支持你自己的css制定。使你的网站看起来更专业。</samp>
 
 &nbsp;&nbsp; 2：允许你自定义对话框的标题。
 
 &nbsp; 3：在ＩＥ７中，可以使你避免使用JavaScript 的prompt（）函数带来的页面重新加载。
 
 &nbsp;&nbsp; 4：这些方法都模拟了Windows的模式对话框。在你改变改变浏览器窗口大小时候，它能够自适应用户
 
 窗口的调整。
 
 &nbsp;&nbsp; 5：如果你引入了[jQuery UI](http://ui.jquery.com/) [Draggable plugin](http://docs.jquery.com/UI/Draggable)插件，那这个插件也可以被自由拖动。
 
 先在这里说插件的下载地址，以供有需之人下载:
 
[http://labs.abeautifulsite.net/projects/js/jquery/alerts/jquery.alerts-1.1.zip](http://labs.abeautifulsite.net/projects/js/jquery/alerts/jquery.alerts-1.1.zip "http://labs.abeautifulsite.net/projects/js/jquery/alerts/jquery.alerts-1.1.zip")

 ### 一：首先在&lt;head&gt;&lt;/head&gt;导入JQuery,jquery.ui.draggable
 
 ### 和jquery.alerts的 css、js文件。
 
	<script src="/path/to/jquery.js" type="text/javascript"></script>

    <script src="/path/to/jquery.ui.draggable.js" type="text/javascript"></script>

    <script src="/path/to/jquery.alerts.js" type="text/javascript"></script>

    <link href="/path/to/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
    
为了在iE中正确的使用alert插件，你还得在Page中加入何时DTD：
 
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 ### 二：使用
 
 我们可以用下列方式来使用这个Jquery插件。
 
1. jAlert(_message, [title, callback])
2. jConfirm(_message, [title, callback])
3. Prompt(_message, [value, title, callback])

 
 
 注：不同于Javascript标准函数，我们可以在message中使用HTML参数显示你的提示信息。

 ### 三：兼容性：
 
 alert插件要求我们必须使用JQuery1.2.6或以上的jQuery包。
 
 已经被测试能够在IE6、IE7、FF2、FF3、Safari 3 、Chrome 、Opera 9浏览器上很好的运行。
 
 ### 四：Demo：
 
 注:在Demo中么有引入dragonable插件所以不能拖拽

Test Alert

	jAlert('This is a custom alert box;<br/>
		<a href=\"http://www.cnblogs.com/whitewolf/\">
		本示例来自破浪博客</a>',
		'Alert Dialog');

Test Confirm

	   jConfirm('Can you confirm this?<br/>
	<a href=\"http://www.cnblogs.com/whitewolf/\">
	本示例来自破浪博客</a>',
	'Confirmation Dialog', function(r) {
	jAlert('Confirmed: ' + r, 'Confirmation Results');
	});

Test Prompt

	jPrompt('Type something:<br/><
	a href=\"http://www.cnblogs.com/whitewolf/\">
	本示例来自破浪博客</a>',
	'WhiteWolf', 'Prompt Dialog', function(r) {
	if( r ) alert('You entered ' + r);
	});



本博客中同类文章还有，请见：[<font color="#6699cc">我jQuery系列之目录汇总</font>](http://www.cnblogs.com/whitewolf/archive/2010/06/09/1754988.html) 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/05/09/1731120.html "原文首发")