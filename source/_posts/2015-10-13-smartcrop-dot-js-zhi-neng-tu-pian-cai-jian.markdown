---
layout: post
title: "smartcrop.js智能图片裁剪"
date: 2015-10-13 21:58:21 +0800
comments: true
categories: [javascript, opensource]
---

今天为大家介绍一款近期github上很不错的开源库 - [smartcrop.js](https://github.com/jwagner/smartcrop.js)。它是一款图片处理智能裁剪库。在很多项目开发中，经常会遇见上传图片的场景，它可能是用户照片信息，也可能是商品图片等，这类图片在我们的网页中展示，往往都具有一定的宽度和高度限制，对于不合法的图片我们会经常为用户提供裁剪的方式来满足这些外在的要求。但是对于网站默认的裁剪区域往往显示在一个固定的位置，而它往往不是精准的用户裁剪位置。而今天为大家所介绍的这一款开源库，就是为了解决这类问题的，为用户提供更好的用户体验。

首先我们可以使用`npm install smartcrop`或者`bower install smartcrop`来下载它。然后像如下方式使用它：

	SmartCrop.crop(image, {
			width: 100,
			height: 100
		}, 
		function(result){
			console.log(result); // {topCrop: {x: 300, y: 200, height: 200, width: 200}}
		});

它将会输出一个比较好的最佳图片裁剪位置，如`{topCrop: {x: 300, y: 200, height: 200, width: 200}}`的数据。

下面是一副来自它的展示网站的案例，请欣赏：

![smartcrop-图片裁剪-案例](/images/blog_img/smartcrop-图片裁剪-案例.png)

更多案例：

1. [http://29a.ch/sandbox/2014/smartcrop/examples/testsuite.html](http://29a.ch/sandbox/2014/smartcrop/examples/testsuite.html)：这里有超过1000个图片效果展示（流量用户请谨慎点击，图片众多）；
2. [http://29a.ch/sandbox/2014/smartcrop/examples/testbed.html](http://29a.ch/sandbox/2014/smartcrop/examples/testbed.html)：这里允许你上传自己的图片，体验其效果；
3. [http://29a.ch/sandbox/2014/smartcrop/examples/slideshow.html](http://29a.ch/sandbox/2014/smartcrop/examples/slideshow.html)：在这里可以尝试用它创建幻灯片。

最后，更多关于smartcrop.js的信息，请参见其github：[https://github.com/jwagner/smartcrop.js](https://github.com/jwagner/smartcrop.js)。