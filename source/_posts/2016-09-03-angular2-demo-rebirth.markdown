---
layout: post
title: "最新Angular2案例rebirth开源"
date: 2016-09-03 22:33:18 +0800
comments: true
categories: [angular2, javascript, rebirth]
---
在过去的几年时间里，Angular1.x显然是非常成功的.但由于最初的架构设计和Web标准的快速发展，逐渐的显现出它的滞后和不适应。这些问题包括性能瓶颈、滞后于急速发展的Web标准、移动化等多平台发展，学习难度等。

所以Angular团队最终决定全新方式构建Angular2框架。Angular2框架现在已经进入RC6版本，很快将进入最终的发布版。Angular2带来了很多不错的特性，它们包括跨平台、高性能、高效开发等。

由于在Angular中引入了render层隔离设计，所以它也很容易实现跨平台的拓展。理论上只需要实现目标平台的render层处理。目前在Angular2的生态圈中已有的跨平台框架如下：

*	Web： [Angular框架自身](https://angular.io/);
*	Universal / Isomorphic: [Universal](https://universal.angular.io/);
*	Progressive Web App: [mobile-toolkit](https://mobile.angular.io/);
*	NativeScript: [nativescript-angular](https://github.com/NativeScript/nativescript-angular);
* 	React Native: [react-native-renderer](https://github.com/angular/react-native-renderer);
*	Ionic2: [Ionic2](http://ionic.io/2/);
*	Electron: [angular-electron](https://github.com/angular/angular-electron/);
*	...

Angular2架构的重新设计，使得其在性能方面也得到了巨大的改善：

*	组件树和单向的@Input、@Output使得变更的影响变得可预知，不再需要Angular1那样多次的digest直到稳定；以及结合`ChangeDetectionStrategy.OnPush`与immutablejs或者是Rxjs，Angular2的变更检查算法复杂度降为了log(n)。相对于Angular1，得到了至少5倍的性能提升；
*	Universal服务端渲染能够更好提升首屏加载的性能；
*	AOT技术引入，能够让组件处理的生成代码提前到构建时期；再加上TypeScript的tree shaking等技术，能够更大化的减小加载JavaScript文件大小和提升运行时性能；
*	Web端Web Worker的实现，能够更好的解放我们的UI线程，得到更好的而用户体验，以及性能的提升；

不仅仅这些，Angular2还有很多的优秀特性。如：基于TypeScript的静态类型检查、拥抱web标准（Shadow dom，fetch API）等等。

总之，Angular2是一门值得我们学习的优秀前端框架。随着Angular2进入了RC6版本，意味发布版将不远了。学习Angular2的时候已到。

========= 未来即将来到

同时笔者也开源了自己的[rebirth](https://github.com/greengerong/rebirth)项目供大家学习。它是一个利用Angular2开发的博客系统前端部分。它涉及到的Angular2知识点非常的全面，包括：组件化，自定义directive，路由，HTTP交互，Template drive form和Reactive form，异步路由，jwt token认证，资源权限控制，动态加载component，jQuery插件集成等常用知识点。

同时[rebirth](https://github.com/greengerong/rebirth)项目也集成了很多前端优秀的技术实践：

*	Angular2 + rxjs
*	bootstrap-sass
*	codemirror + markdownit(online markdown文档编辑器)
*	webpack2 + DashboardPlugin(代码打包)
* 	TypeScript2 + @types 
*	stubby(数据mock框架)
*	tslint + codelyzer(ts代码和Angular2组件静态检查)
*	angular2-template-loader(Angular2 component的html、css打包)
*	karma + phantomjs(TDD开发)
*	sass + postcss(css样式组织)
*	typedoc(ts文档)
*	fontgen-loader(icon font)

在这里为大家放上几张[rebirth](https://github.com/greengerong/rebirth)效果图，供大家预览：

移动端样式：

<img src="https://cloud.githubusercontent.com/assets/2569893/17268750/bd6fe296-5666-11e6-84e0-c78d9b8c29d2.png"  style="max-width:300px;" />

PC端样式：

![https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-index.png](https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-index.png)

![https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-manage-list.png](https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-manage-list.png)

![https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-manage-edit.png](https://github.com/greengerong/rebirth/raw/master/shortscreens/rebirth-manage-edit.png)


希望大家能喜欢。有任何的问题可以在笔者的github提issue，笔者会在空闲时间为大家解答。


