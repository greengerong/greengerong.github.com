---
layout: post
title: "(译)你应该知道的jQuery技巧"
date: 2015-11-20 18:54:40 +0800
comments: true
categories: [javascript, jquery]
---

帮助提高你jQuery应用的简单小技巧。

1. 	回到顶部按钮
2.	图片预加载
3.	判断图片是否加载完
4.	自动修补破损图像
5.	Hover切换class类
6.	禁用输入
7.	停止正在加载的链接
8.	toggle fade/slide
9.	简单的手风琴
10.	使两个DIV同等高度
11.	在浏览器标签/新窗口打开外部链接
12.	根据文本获取元素
13.	可见变化的触发
14.	Ajax调用错误处理
15.	链式操作

###回到顶部按钮
利用jQuery里的animate和scrollTop方法，你便不需要使用插件创建简单的滚动到顶部动画。

	// Back to top
	$('.top').click(function (e) {
	  e.preventDefault();
	  $('html, body').animate({scrollTop: 0}, 800);
	});
	<!-- Create an anchor tag -->
	<a class="top" href="#">Back to top</a>

通过scrollTop的值来改变你想要滚动到的位置。其实你就是做了：在接下来的800毫秒中让页面滚动，直到它滚动到文档的顶部。

**备注**：来看一些scrollTop的调皮行为 。

###图片预加载
如果你的网页使用了很多隐藏图片文件（例如：鼠标悬停展示的图片），那么图片的预加载是有意义的：

	$.preloadImages = function () {
	  for (var i = 0; i < arguments.length; i++) {
	    $('<img>').attr('src', arguments[i]);
	  }
	};

	$.preloadImages('img/hover-on.png', 'img/hover-off.png');

判断图片是否加载完有时候你可能需要检查图像是否已经加载完成，以便于可以继续执行相应的js代码：

	$('img').load(function () {
	  console.log('image load successful');
	});

你还可以检查一个特定的图片是否加载完并且被带有Id或者class的`<img>`标签代替。

自动修补破损图像如果你碰巧发现在你的网站上发现破损的图像链接，一个个去替代他们是痛苦的。这个简单的代码可以节省很多的麻烦：

	$('img').on('error', function () {
	  if(!$(this).hasClass('broken-image')) {
	    $(this).prop('src', 'img/broken.png').addClass('broken-image');
	  }
	});

即使你没有任何断开的链接，加入这代码也不会有任何影响。

###Hover切换class类
比方说，当用户将鼠标悬停在你页面上的元素时，你想改变其视觉效果。当用户鼠标悬停在元素上，你可以在该元素上添加一个class类，当鼠标停止悬停事件时移除此class类：

	$('.btn').hover(function () {
	  $(this).addClass('hover');
	}, function () {
	  $(this).removeClass('hover');
	});

如果你想要一个更简单的方式使用toggleClass方法，则仅仅需要添加必要的CSS：

	$('.btn').hover(function () {
	  $(this).toggleClass('hover');
	});

*备注*：CSS可以在这种情况下是一个快速的解决方案，但要知道这依旧是值得了解的。

###禁用输入
有时你可能需要用表单的提交按钮或者某个输入框直到用户执行了某个动作（比如：检查“我已阅读条款”复选框）。在你的输入框上设置disabled属性，然后当你需要的时候启用该属性：

	$('input[type="submit"]').prop('disabled', true);

你需要做的只是需要在输入框上再次运行pop方法，但设置的被禁用值是false：

	$('input[type="submit"]').prop('disabled', false);

停止正在加载的链接有时你不想链接到特定的网页或者重新载入页面；你可能想让他们做一些其他事情，如触发一些其他的脚本。这是防止违约行动的技巧：

	$('a.no-link').click(function (e) {
	  e.preventDefault();
	});

toggle fade/slide滑动和淡入/淡出 是我们在jQuery中经常大量使用的动画。你可能仅仅想在用户做某些点击事件的时候显示一个元素，这时候需要淡入/淡出或者滑动方法。但是如果你需要那个元素在你第一次点击的时候出现，在第二次点击的时候消失，代码如下：

	// Fade
	$('.btn').click(function () {
	  $('.element').fadeToggle('slow');
	});

	// Toggle
	$('.btn').click(function () {
	  $('.element').slideToggle('slow');
	});

	简单的手风琴
	这是个简单快速的方法创建一个手风琴：

	// Close all panels
	$('#accordion').find('.content').hide();

	// Accordion
	$('#accordion').find('.accordion-header').click(function () {
	  var next = $(this).next();
	  next.slideToggle('fast');
	  $('.content').not(next).slideUp('fast');
	  return false;
	});

通过添加这个脚本，你需要做的则是必要的HTML操作在你的页面上。

使两个DIV同等高度有时你会想要两个DIV有相同的高度，无论他们都有什么内容：

	$('.div').css('min-height', $('.main-div').height());

这个例子设置了DIV的最小高度，这意味着它的高度只可以比这个设置的高度大而不能小。然而，一个更灵活的方法是循环的一组元素，并设置将最高元素的高度作为高度：

	var $columns = $('.column');
	var height = 0;
	$columns.each(function () {
	  if ($(this).height() > height) {
	    height = $(this).height();
	  }
	});
	$columns.height(height);

	如果你想要所有的列有相同的高度：

	var $rows = $('.same-height-columns');
	$rows.each(function () {
	  $(this).find('.column').height($(this).height());
	});

###在浏览器标签/新窗口打开外部链接
在新的浏览器标签或窗口中打开外部链接，并确保在同一个标签或窗口中打开的是同一个源的链接：

	$('a[href^="http"]').attr('target', '_blank');
	$('a[href^="//"]').attr('target', '_blank');
	$('a[href^="' + window.location.origin + '"]').attr('target', '_self');

*备注*：window.location.origin 在IE10不工作。

###根据文本获取元素
通过jQuery中的contains()选择器，你能找到一个元素内的文本内容。如果文本不存在，则这个元素将被隐藏：

	var search = $('#search').val();
	$('div:not(:contains("' + search + '"))').hide();

可见变化的触发当用户不再聚焦或者重新聚焦一个标签时触发javascript脚本：

	$(document).on('visibilitychange', function (e) {
	  if (e.target.visibilityState === "visible") {
	    console.log('Tab is now in view!');
	  } else if (e.target.visibilityState === "hidden") {
	    console.log('Tab is now hidden!');
	  }
	});

###Ajax调用错误处理
当一个Ajax调用返回一个404或500的错误时，将执行该错误处理。如果该处理未定义，则其他jQuery代码便可能不会执行了。定义一个全局Ajax错误处理程序：

	$(document).ajaxError(function (e, xhr, settings, error) {
	  console.log(error);
	});

链式操作jQuery允许通过链式操作来减轻反复查询DOM和创建多个jQuery对象的过程。比如下面是你的方法调用：

	$('#elem').show();
	$('#elem').html('bla');
	$('#elem').otherStuff();

这代码可以通过链式大大的提高：

	$('#elem')
	  .show()
	  .html('bla')
	  .otherStuff();

另一个方法是在一个可变的元素缓存（$作为前置）：

	var $elem = $('#elem');
	$elem.hide();
	$elem.html('bla');
	$elem.otherStuff();

链式和jQuery缓存方法是最好的做法，导致更短、更快的代码。


翻译：野兽

英文原文地址：[https://github.com/AllThingsSmitty/jquery-tips-everyone-should-know](https://github.com/AllThingsSmitty/jquery-tips-everyone-should-know)。