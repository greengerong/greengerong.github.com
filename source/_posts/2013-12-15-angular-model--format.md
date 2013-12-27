---
layout: post
title: "angular ng-model类型格式转化"
description: ""
category: "angular"
tags: [angularjs]
---
在angular开发中我们经常会遇见输入框中的string的值，却想在scope上的model表现为整型、浮点、货币，或者在radio的value是一个true,false的Boolean类型，一组check box的vlue组成一个Array的数组类型，因为我们的后台程序的model设计接口如此。你是否还在后台应用程序或者ajax提交前做mapper，还在重复着着伪angular的做法？

在本人github创建了一个开源项目[https://github.com/greengerong/ngmodel-format](https://github.com/greengerong/ngmodel-format),为了让我们能够轻易的对付这些琐事，你可以在demo下得html或者middle way的测试中看见其使用方法，同时如果不满足你的需求，你仍然可以很简单的扩展你需要的功能：你需要的只是在你的module的run阶段注入modelFormatConfig的constant service 加入所需的key值，加上自己的formatter，parser，isEmpty方法，如果你仍然想继续深入的对用户的输入进行一些控制的话，也可以加入keyDown时间去stopPropagation，preventDefault一些key值。

下面我们看看其相应的使用方式：


请移步到[http://jsbin.com/uJUrANa/1/watch?html,js,output](http://jsbin.com/uJUrANa/1/watch?html,js,output)，由于嵌入iframe对样式存在影响，所以暂不嵌入


注意由于在jsbin拒绝引入github text/plain的文件 所以这里是直接把源码贴进去了的，如果使用的话最好是使用github上的，这里的代码是不会更新的。

在jsbin demo上你能够很清楚的看见使用方式。那么我就不用在废话多说了，哈哈。有问题可以提交github issue。