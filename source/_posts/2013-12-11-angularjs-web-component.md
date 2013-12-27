---
layout: post
title: "web组件化-angularjs实践"
description: ""
category: "angularjs"
tags: [angularjs,web组件化]
---
在过去的web标准经历了一个飞速的发展，随着时间的推移，用户对web的体验也越来越重视，从最初的简单静态页面到以ajax标志的web2.0，在这个时代我们所面临的问题是用户的体验和可恶的浏览器的兼容(IE成为了我们所唾弃的产物，IE6的葬礼之类的形式足以表明这点)，所以有了Prototype，Mootools，jQuery这类浏览器兼容和util的库，特别jQuery的出现以其独特的兼容性，一致性和优雅的选择器和链式风格影响了整个业界的发展,作为这个时代的产物jQuery是个很出色的库，正的如它所说，做到了"write less，do more",成为这个时代的标志。然而随着互联网的突增，我们的JavaScript代码量也暴增，是的我们再度陷入到JavaScript的维护管理的困境。JavaScript本来是一门作为浏览器上的脚本语言出身，并不适合于大规模开发。所以在我们所能看见的MDV框架的出现，这个时候前段的JavaScript代码已得到我们越来越注重，MDV框架提出了我们也需要向对待后端系统(spring,web api)一样对前段逻辑进行统一管理，分层(表现逻辑，viewmodel，视图)。所以Backbone，AngularJS，Ember，Spine之类的数据绑定框架横空出世，力求给我们带来代码的模块管理，数据、视图的分离，他们以他们不同的方式解决共同的问题：

1.如何更好地模块化开发

2.业务数据如何组织

3.界面和业务数据，业务逻辑的分离

与此同时其实用户体验的要求html5，ECMAScript也在快速的推进。在这里我想说的是 Web组件化的也在蓬勃的发展起来，以Google额polymer为代表的框架，库也在悄无声息的到来，虽然这需要等到浏览器的大统一，但是我们相信在不久的将来将会到来。在这里我所激动和希望是组件的共享，假设我们能够一个想java maven repo，cdn之类的共有或者私有repo，在你需要的地方只需要import那将是多么美好的事情，这也许是意淫，但也未必不可。

有希望总是好的，在过去一年我所尝试的就是基于angular这优秀的框架directive dsl和maven build去实现我所期望的组件化共享愿景。在基于node的[component](http://component.io/)前端管理框架稍有相似之处。

回到正题，在angularjs中如何去做到组件化：


![https://github.com/greengerong/greengerong.github.com/blob/master/_post_img/prerender.jpg?raw=true](https://github.com/greengerong/greengerong.github.com/blob/master/_post_img/web-angular.jpg?raw=true)



