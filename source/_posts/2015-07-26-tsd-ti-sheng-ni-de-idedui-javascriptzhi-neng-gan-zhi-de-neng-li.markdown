---
layout: post
title: "tsd-提升你的IDE对JavaScript智能感知的能力"
date: 2015-07-26 00:55:31 +0800
comments: true
categories: [JavaScript, tsd, TypeScript]
---
在编写前端JavaScript代码时，最痛苦的莫过于代码的智能感知（Intelli Sense）。

追其根源，是因为JavaScript是一门弱类型的动态语言。对于弱类型的动态语言来说，智能感知就是IDE工具的一个“软肋”。IntelliJ等IDE所用智能感知方式，是一种折中的方式：全文搜索，然后展示出已经使用过的对象成员。这种方式的缺点是，其智能感知的的能力并不精准，经常会显示出很多无关的代码提示。

在很多现代化开发方式中，IDE的强大支持和模块化组织这种“工程化”的思想是我们应对大规模开发的方式之一，这也已经被业界所认同。所以在最近两年，JavaScript的世界也提出了大规模开发的方案，其中有Google的Dart和微软的TypeScript。随着Angular2.0放弃了自家的Dart，而选择了TypeScript，也标志着TypeScript的逐渐成熟。TypeScript是微软总架构师Anders Hejlsberg设计的新语言，他是软件界的传奇人物，是Delphi和.NET的设计者。TypeScript是一种可以编译成传统JavaScript的语言，它并不是完全的创造了一门新语言，而TypeScript是JavaScript语言的超集，它最大的特点就是引入了类型系统。并在编译为JavaScript文件后，可以输出“.ts”的类型元数据信息，为我们IDE的智能感知和重构提供了重要的依据。

关于TypeScript的更多知识，在这里笔者就不在叙述过多。有兴趣的读者可以到<http://www.typescriptlang.org/>学习，本节要讲的，是它的另一个特性：它编译输出的元数据信息文件（`*.d.ts`），它可以在不需要修改原有JavaScript文件的情况下，而给JavaScript添加元数据类型信息，而这些类型信息则可以辅助IDE，给出有智能的提示信息，以及重构的依据。

在TypeScript的开源社区，已经为很多的第三方库实现了这类模板文件，我们可以很快的应用在我们的项目之中。当然这里所说的额第三方包含我们常用的：Angular、jQuery、underscore、lodash、jasmine等。

在官方同时也为我们提供了一个方便的工具叫TSD（全称为：TypeScript Definition manager for DefinitelyTyped），它是借鉴NPM包管理工具的思想，实现了一个类似的包管理工具，我们不需要任何的学习成本，只管像使用NPM一样使用它。

这里是TSD主页:[http://definitelytyped.org/tsd/](http://definitelytyped.org/tsd/)，你可以在这里深入了解它，或者是查询你所需要的模板库是否存在于TSD仓库。

TSD也是一个Nodejs的工具，所以我们安装它非常容易，只需要在命令行中输入（对于有些Linux用户需要sudo）：

	npm install tsd -g

安装我们需要的模板库，也很简单，如jQuery和Angular的安装：

	tsd install jquery angular --save


这样TSD就会帮助我们下载jQuery和Angular的d.ts文件，并存放在当前目录的typings独立子目录下，并且它会将我们需要的依赖信息保存在一个叫tsd.json的文件，如NPM的package.json一样，方便于我们的版本管理，以及团队之间的共享。我们只需要共享这个tsd.json文件给其他同事，然后

	tsd install

一切都可以满意就绪了。

tsd.json文件的格式如下：

![tsd文件目录](/images/blo_img/tsd-install.png)

同时候TSD工具还会为我们在typing目录下生产一个tsd.d.ts文件，它会为我们引入这些模板文件，使得IDE能够识别出这样模板文件：

	/// <reference path="angularjs/angular.d.ts" />
	/// <reference path="jquery/jquery.d.ts" />

下面是我们在Intellij中得到的智能感知图：

![tsd智能感应](/images/blo_img/tsd-intellij-智能感应.png)

目前能够很好支持TypeScript这一特性的工具有：Intellij家族、微软自家的VS工具、Sublime。有了TSD这一工具，也许我们虽然还不能尝试TypeScript的特性，但我们仍然可以利用它来帮助我们的普通JavaScript开发。