---
layout: post
title: "语言设计中的鸭子类型风格"
description: "语言设计中的鸭子类型风格"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; &nbsp; &nbsp; 在动态语言的世界里一直流传着一种叫做鸭子类型的风格，其来自谚语：&ldquo;如果行鸭子一样走路，像鸭子一样呱呱叫，那它就是一只鸭子&rdquo;。

&nbsp;&nbsp;&nbsp;&nbsp; 从鸭子类型，我们可以联想到它的推导，并不在乎类型的真正实体，只要他的行为有鸭子的特性，那么我们就可以把它当做一只鸭子来看到。在动态语言设计中，可以解释为无论一个对象是什么类型的，只要它具有某类型的行为（方法），则它就是这一类型的实例，而不在于它是否显示的实现或者继承。

&nbsp;&nbsp;&nbsp;&nbsp; 鸭子类型在动态语言中被广为奉行。某类接口需要一个log接口，换句话说这借口中需要调用传入对象的log，方法，在动态语言中无论你传入的是什么对象，只有具有log方法则就是合法的。而java，c#这类静态强类型语言（当前首先声明c#已经不是纯的静态强类型语言，它具有dynamic，表达式，当然这里所说的c#是去掉这类特性，或者说C#2.0吧）我们传入的对象是必须显示实现该接口的类实例，他们直接必须具有显示的继承链。

&nbsp;&nbsp; &nbsp;&nbsp;以上所说的是两类语言设计中的对抽象的制约的区别。

&nbsp;&nbsp;&nbsp; Javascript中鸭子型的实现：

<div class="cnblogs_code">
<pre><span style="color: #0000ff;">function</span><span style="color: #000000;"> log(logger){

       logger.log(&ldquo;hello world&rdquo;)；

}

log({log:</span><span style="color: #0000ff;">function</span><span style="color: #000000;">(msg){

       console.log(msg);

}});</span></pre>
</div>

&nbsp;

代码量很少，这里只是一种简单的约定，而不是强制，使得我们的自控感增强，所以我喜欢javascript这门语言给我的自由度。但是相对于java这类静态强类型语言而言是将语法的检查推向了运行时期，延迟了发现问题的时间，不助于我们的调试。在强类型系统的语言中由于具有完备的类型信息，我们可以提高良好的IDE于开发时限制，有助于我们的大规模开发。所以这里没有对错，只是看你的选择和喜爱。如果你是一个优秀的程序员，动态语言这种检查的推迟对你并无什么问题，因为你能够有条理次序的节奏型开发。

&nbsp;&nbsp;&nbsp;&nbsp; 关于鸭子型风格这里还得必须提到go语言，也是go语言带来我对这种风格的思考。

我们还可以显示的定义在消费者方法中，形如&nbsp;

<div class="cnblogs_code">
<pre>func SomeFunction(logger <span style="color: #0000ff;">interface</span>{Log(<span style="color: #0000ff;">string</span><span style="color: #000000;">)}){

    logger.Log(&ldquo;hello world, I am go lang&rdquo;).

}</span></pre>
</div>

&nbsp;

实现提供者：

<div class="cnblogs_code">
<pre>type S <span style="color: #0000ff;">struct</span><span style="color: #000000;"> { }

func (</span><span style="color: #0000ff;">this</span> *S)Log(msg <span style="color: #0000ff;">string</span><span style="color: #000000;">) {

    console.log(msg)

}</span></pre>
</div>

&nbsp;

在类型S就是一个实现了Logger的实例。

&nbsp;

Go还有一种叫做空接口，能够容纳万物的东西;

<div class="cnblogs_code">
<pre>func log(any <span style="color: #0000ff;">interface</span>{}) <span style="color: #0000ff;">int</span><span style="color: #000000;"> {

    </span><span style="color: #0000ff;">return</span><span style="color: #000000;"> any.(I).Get()

 }</span></pre>
</div>

&nbsp; &nbsp;Go语言不同于其他鸭子类型语言的是它实现了在编译时期检查，同时也不失这种自由度。

&nbsp;&nbsp;&nbsp; 另外TypeScript想必你也知道 ，这与google的dart一样致力于将javascript带入大规模开发的语言，不同的是TypeScript是javascript的超集，并不是重造一门新语言。他为javascript引入的接口，类型，泛型等较完备的类型系统，是的能够有更好的IDE支持，从某种程度上来说，这是对鸭子类型或者javascript编译器的检查推迟的弥补。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/06/30/3163358.html "原文首发")