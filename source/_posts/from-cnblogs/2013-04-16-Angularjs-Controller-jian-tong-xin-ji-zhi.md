---
layout: post
title: "Angularjs Controller 间通信机制"
description: "Angularjs Controller 间通信机制"
category: cnblogs
tags: [code,cnblogs]
---
<span style="font-size: 16px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在[Angularjs开发一些经验总结](http://www.cnblogs.com/whitewolf/archive/2013/03/24/2979344.html)随笔中提到我们需要按照业务却分angular controller，避免过大无所不能的上帝controller，我们把controller分离开了，但是有时候我们需要在controller中通信，一般为比较简单的通信机制，告诉同伴controller我的某个你所关心的东西改变了，怎么办？如果你是一个javascript程序员你会很自然的想到异步回调响应式通信&mdash;事件机制(或消息机制)。对，这就是angularjs解决controller之间通信的机制，所推荐的唯一方式，简而言之这就是angular way。</span>

## <span style="font-size: 16px; font-family: 楷体;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Angularjs为在scope中为我们提供了冒泡和隧道机制，$broadcast会把事件广播给所有子controller，而$emit则会将事件冒泡传递给父controller，$on则是angularjs的事件注册函数，有了这一些我们就能很快的以angularjs的方式去解决angularjs controller之间的通信，代码如下：</span>

## <span style="font-size: 16px; font-family: 楷体;">View:</span>

<div class="cnblogs_code">
<pre><span style="color: #008080;">1</span> <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">div </span><span style="color: #ff0000;">ng-app</span><span style="color: #0000ff;">="app"</span><span style="color: #ff0000;"> ng-controller</span><span style="color: #0000ff;">="parentCtr"</span><span style="color: #0000ff;">&gt;</span>
<span style="color: #008080;">2</span>     <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">div </span><span style="color: #ff0000;">ng-controller</span><span style="color: #0000ff;">="childCtr1"</span><span style="color: #0000ff;">&gt;</span><span style="color: #000000;">name :
</span><span style="color: #008080;">3</span>         <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">input </span><span style="color: #ff0000;">ng-model</span><span style="color: #0000ff;">="name"</span><span style="color: #ff0000;"> type</span><span style="color: #0000ff;">="text"</span><span style="color: #ff0000;"> ng-change</span><span style="color: #0000ff;">="change(name);"</span> <span style="color: #0000ff;">/&gt;</span>
<span style="color: #008080;">4</span>     <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">div</span><span style="color: #0000ff;">&gt;</span>
<span style="color: #008080;">5</span>     <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">div </span><span style="color: #ff0000;">ng-controller</span><span style="color: #0000ff;">="childCtr2"</span><span style="color: #0000ff;">&gt;</span><span style="color: #000000;">Ctr1 name:
</span><span style="color: #008080;">6</span>         <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">input </span><span style="color: #ff0000;">ng-model</span><span style="color: #0000ff;">="ctr1Name"</span> <span style="color: #0000ff;">/&gt;</span>
<span style="color: #008080;">7</span>     <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">div</span><span style="color: #0000ff;">&gt;</span>
<span style="color: #008080;">8</span> <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">div</span><span style="color: #0000ff;">&gt;</span></pre>
</div>

<span style="font-size: 16px; font-family: 楷体;">Controller:</span>

<div class="cnblogs_code">
<pre><span style="color: #008080;"> 1</span> angular.module("app", []).controller("parentCtr"<span style="color: #000000;">,
</span><span style="color: #008080;"> 2</span> <span style="color: #0000ff;">function</span><span style="color: #000000;"> ($scope) {
</span><span style="color: #008080;"> 3</span>     $scope.$on("Ctr1NameChange"<span style="color: #000000;">,
</span><span style="color: #008080;"> 4</span>  
<span style="color: #008080;"> 5</span>     <span style="color: #0000ff;">function</span><span style="color: #000000;"> (event, msg) {
</span><span style="color: #008080;"> 6</span>         console.log("parent"<span style="color: #000000;">, msg);
</span><span style="color: #008080;"> 7</span>         $scope.$broadcast("Ctr1NameChangeFromParrent"<span style="color: #000000;">, msg);
</span><span style="color: #008080;"> 8</span> <span style="color: #000000;">    });
</span><span style="color: #008080;"> 9</span> }).controller("childCtr1", <span style="color: #0000ff;">function</span><span style="color: #000000;"> ($scope) {
</span><span style="color: #008080;">10</span>     $scope.change = <span style="color: #0000ff;">function</span><span style="color: #000000;"> (name) {
</span><span style="color: #008080;">11</span>         console.log("childCtr1"<span style="color: #000000;">, name);
</span><span style="color: #008080;">12</span>         $scope.$emit("Ctr1NameChange"<span style="color: #000000;">, name);
</span><span style="color: #008080;">13</span> <span style="color: #000000;">    };
</span><span style="color: #008080;">14</span> }).controller("childCtr2", <span style="color: #0000ff;">function</span><span style="color: #000000;"> ($scope) {
</span><span style="color: #008080;">15</span>     $scope.$on("Ctr1NameChangeFromParrent"<span style="color: #000000;">,
</span><span style="color: #008080;">16</span>  
<span style="color: #008080;">17</span>     <span style="color: #0000ff;">function</span><span style="color: #000000;"> (event, msg) {
</span><span style="color: #008080;">18</span>         console.log("childCtr2"<span style="color: #000000;">, msg);
</span><span style="color: #008080;">19</span>         $scope.ctr1Name =<span style="color: #000000;"> msg;
</span><span style="color: #008080;">20</span> <span style="color: #000000;">    });
</span><span style="color: #008080;">21</span> });</pre>
</div>

<span style="font-size: 16px; font-family: 楷体;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 这里childCtr1的name改变会以冒泡传递给父controller，而父controller会对事件包装在广播给所有子controller，而childCtr2则注册了change事件，并改变自己。注意父controller在广播时候一定要改变事件name。</span>

<span style="font-size: 16px;">jsfiddle链接：[http://jsfiddle.net/whitewolf/5JBA7/15/](http://jsfiddle.net/whitewolf/5JBA7/15/)</span>

&nbsp;

<iframe width="100%" height="300" src="http://jsfiddle.net/whitewolf/5JBA7/15/embedded/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/04/16/3024843.html "原文首发")