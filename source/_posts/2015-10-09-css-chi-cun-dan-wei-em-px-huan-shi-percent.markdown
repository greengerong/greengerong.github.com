---
layout: post
title: "CSS尺寸和字体单位-em、px还是%"
date: 2015-10-09 07:00:04 +0800
comments: true
categories: [css]
---

在页面整体布局中，页面元素的尺寸大小（长度、宽度、内外边距等）和页面字体的大小也是重要的工作之一。一个合理设置，则会让页面看起来层次分明，重点鲜明，赏心悦目。反之，一个不友好的页面尺寸和字体大小设置，则会增加页面的复杂性，增加用户对页面理解的复杂性；甚至在当下访问终端（iPhone、iPad、PC、Android...）层出不穷的今天，适应各式各样的访问终端，将成为手中的一块“烫手的山芋”。所以在近几年，“九宫格”式的“流式布局”再度回归。为了提供页面布局，及其它的可维护性、可扩展性，我们尝试将页面元素的大小，以及字体大小都设置为相对值，不再是孤立的固定像素点。使其能在父元素的尺寸变化的同时，子元素也能随之适应变化。以及结合少量最新CSS3的@media查询，来实现“响应式布局”，bootstrap这类CSS框架大势兴起。

然而在CSS中，W3C文档把尺寸单位划为为两类：相对长度单位和绝对长度单位。然而相对长度单位按照不同的参考元素，又可以分为字体相对单位和视窗相对单位。字体相对单位有：em、ex、ch、rem；视窗相对单位则包含：vw、vh、vmin、vmax几种。绝对定位则是固定尺寸，它们采用的是物理度量单位：cm、mm、in、px、pt以及pc。但在实际应用中，我们使用最广泛的则是em、rem、px以及百分比（%）来度量页面元素的尺寸。

1. px：为像素单位。它是显示屏上显示的每一个小点，为显示的最小单位。它是一个绝对尺寸单位；
2. em：它是描述相对于应用在当前元素的字体尺寸，所以它也是相对长度单位。一般浏览器字体大小默认为16px，则2em == 32px；
3. %： 百分比，它是一个更纯粹的相对长度单位。它描述的是相对于父元素的百分比值。如50%，则为父元素的一半。

这里需要注意的是：em是相对于应用于当前当前元素的字体尺寸；而百分比则是相对于父元素的尺寸。如下面示例：

HTML：

	<div class="parent">
	 	 <div class="em-demo">
		  设置长度为5em demo
	 	 </div>
	
		 <div class="percentage-demo">
		  设置长度为80% demo
	 	 </div>
	</div>

CSS：

	div{
		border: 1px dashed #808080;
		margin:10px
	}

	.parent{
		width: 200px;
		font-size: 18px;
	}

	.em-demo{
		width: 5em;
	}

	.percentage-demo{
		width: 80%
	}

则其效果图为([http://jsbin.com/xihusojale/edit?html,css,output](http://jsbin.com/xihusojale/edit?html,css,output))：

![em percentage demo](/images/blog_img/em-percentage-demo.png)

从图上我们可以看出：设置5em的div的第一行字符刚好为5个字符大小，因为如上所说，它是相对于当前元素字体的尺寸， 5 * 18 = 90px。而百分比显示则会比较大一些，因为它是相对于父元素的尺寸比例， 200 * 80% = 160px。

当然，在


