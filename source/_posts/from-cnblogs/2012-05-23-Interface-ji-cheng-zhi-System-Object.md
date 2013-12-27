---
layout: post
title: "Interface继承至System.Object？"
description: "Interface继承至System.Object？"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp; 这其实是个很基础的问题，在我们学习C#类型的时候第一句就是所有的对象都继承至System.Object。今天一个同事问我Interface继承之System.Object。所以才有了本文。

&nbsp; 在这里我只从几个方面简单的说明：

&nbsp; 1：从语义：

&nbsp;&nbsp;&nbsp;&nbsp; Interface在oo中表示一组行为的集合，是高层次的抽象，契约，一种稳定的表现。好比我们生活的公司和员工之间的合同，双方都必须遵循。所以我们的接口必须是一个干净纯洁的体系。加入interface继承之System.Object，这以为这是不是，Interface有Equal，ToString等方法？这明显破坏了接口的干净体系。

2：实践（C#）：

&nbsp;&nbsp; 如果interface继承之System.Object，这我们可以从System.Type获取其基类：

如下测试：

public interface Itest{}

public class test{}

typeof(Itest).BaseTye//为null

typeof(test).BaseType//System.Object.

3:我们从IL指令来看（这也是最有力的证明）：

我们先写一个接口和一个类，他们都是空实现：

namespace ConsoleApplication1    
{     
&nbsp;&nbsp;&nbsp; public class test     
&nbsp;&nbsp;&nbsp; {     
&nbsp;&nbsp;&nbsp; } 

&nbsp;&nbsp;&nbsp; public interface Itest    
&nbsp;&nbsp;&nbsp; {     
&nbsp;&nbsp;&nbsp; }     
}

&nbsp;

在反编译查看IL：

test clas:

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201205/20120523000419947.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201205/201205230004187699.png) 

而interface Itest的IL：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201205/201205230004208405.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201205/201205230004197566.png) 

从上面两个IL比较我们可以清晰的看出来class有显示的extends [mscorlib]System.Object，而接口没有，本篇的答案到这里你应该很清晰吧。这里还需要说明的是他们都是class，说明都是一种类型，而interface是一种特殊的类型。

接口能定义什么？接口能定义行为（方法），无参属性（属性，又称守信），有参属性（索引），不能定义私例字段，定义都是对编译器都是一组方法行为。

&nbsp;&nbsp; 在最后我们在来说说前面说的&#8220;所有的对象都继承至System.Object&#8221;，这是真的嘛？在c#的编译过程中为我们提供了一个选项NOAUTOINHERIT，是的我们可以为自定义类型去掉默认的System.Object的基类。这就打破了System.Object创世之祖的戒律。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/05/23/2514123.html "原文首发")