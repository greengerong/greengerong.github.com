---
layout: post
title: "edge.js架起node.js和.net互操作桥梁"
description: "edge.js架起node.js和.net互操作桥梁"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 今天要介绍的是edge.js这个github上刚兴起的开源项目，它可以让node.js和.net之间在in-process下互操作。.net版本在4.5及以上，因为.net4.5带来的Task，asyn，await关键字和node.js的Event模型正好匹配。如果你感兴趣的话，可以参见github[https://github.com/tjanczuk/edge](https://github.com/tjanczuk/edge "https://github.com/tjanczuk/edge") 和[Edge.js overview](http://tjanczuk.github.com/edge).

下面这幅图展示了edge.js在node.js和.net之间互操作的桥梁。Fun&lt;object,Task&lt;object&gt;&gt;表示输入为object类型，输出为Task&lt;object&gt;,后者对应node.js中的回调函数，前者则为.net方法输入参数。更多详情请参见github readme。

&nbsp;&nbsp; ![edge.js interop model](https://f.cloud.github.com/assets/822369/234085/b305625c-8768-11e2-8de0-e03ae98e7249.PNG)

&nbsp;&nbsp; 下面我们写个菲波基数作为demo尝鲜：完整项目寄宿在github：[edge-demo](https://github.com/greengerong/edge-demo)。

<div class="cnblogs_code">
<pre><span style="color: #008080;"> 1</span> <span style="color: #0000ff;">var</span> edge = require('edge'<span style="color: #000000;">);
</span><span style="color: #008080;"> 2</span> 
<span style="color: #008080;"> 3</span> <span style="color: #0000ff;">var</span> fib =<span style="color: #000000;"> edge.func({
</span><span style="color: #008080;"> 4</span>     source: <span style="color: #0000ff;">function</span>() {<span style="color: #008000;">/*</span>
<span style="color: #008080;"> 5</span> 
<span style="color: #008080;"> 6</span> <span style="color: #008000;">        using System;
</span><span style="color: #008080;"> 7</span> <span style="color: #008000;">        using System.Linq;
</span><span style="color: #008080;"> 8</span> <span style="color: #008000;">        using System.Threading.Tasks;
</span><span style="color: #008080;"> 9</span> 
<span style="color: #008080;">10</span> <span style="color: #008000;">        public class Startup
</span><span style="color: #008080;">11</span> <span style="color: #008000;">        {       
</span><span style="color: #008080;">12</span> <span style="color: #008000;">             public async Task&lt;object&gt; Invoke(object input)
</span><span style="color: #008080;">13</span> <span style="color: #008000;">            {
</span><span style="color: #008080;">14</span> <span style="color: #008000;">                int v = (int)input;
</span><span style="color: #008080;">15</span> <span style="color: #008000;">                var fib = Fix&lt;int, int&gt;(f =&gt; x =&gt; x &lt;= 1 ? 1 : f(x - 1) + f(x - 2));
</span><span style="color: #008080;">16</span> <span style="color: #008000;">                return fib(v);
</span><span style="color: #008080;">17</span> <span style="color: #008000;">            }
</span><span style="color: #008080;">18</span> 
<span style="color: #008080;">19</span> <span style="color: #008000;">            static Func&lt;T, TResult&gt; Fix&lt;T, TResult&gt;(Func&lt;Func&lt;T, TResult&gt;, Func&lt;T, TResult&gt;&gt; f)
</span><span style="color: #008080;">20</span> <span style="color: #008000;">            {
</span><span style="color: #008080;">21</span> <span style="color: #008000;">                return x =&gt; f(Fix(f))(x);
</span><span style="color: #008080;">22</span> <span style="color: #008000;">            }
</span><span style="color: #008080;">23</span> 
<span style="color: #008080;">24</span> <span style="color: #008000;">            static Func&lt;T1, T2, TResult&gt; Fix&lt;T1, T2, TResult&gt;(Func&lt;Func&lt;T1, T2, TResult&gt;, Func&lt;T1, T2, TResult&gt;&gt; f)
</span><span style="color: #008080;">25</span> <span style="color: #008000;">            {
</span><span style="color: #008080;">26</span> <span style="color: #008000;">                return (x, y) =&gt; f(Fix(f))(x, y);
</span><span style="color: #008080;">27</span> <span style="color: #008000;">            }
</span><span style="color: #008080;">28</span> <span style="color: #008000;">        }
</span><span style="color: #008080;">29</span> 
<span style="color: #008080;">30</span>     <span style="color: #008000;">*/</span><span style="color: #000000;">},
</span><span style="color: #008080;">31</span>     references: ['System.Core.dll'<span style="color: #000000;">]
</span><span style="color: #008080;">32</span> <span style="color: #000000;">});
</span><span style="color: #008080;">33</span> 
<span style="color: #008080;">34</span> fib(5, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (error, result) {
</span><span style="color: #008080;">35</span>     <span style="color: #0000ff;">if</span><span style="color: #000000;"> (error) console.log(error);
</span><span style="color: #008080;">36</span> <span style="color: #000000;">    console.log(result);
</span><span style="color: #008080;">37</span> <span style="color: #000000;">});
</span><span style="color: #008080;">38</span> 
<span style="color: #008080;">39</span> <span style="color: #0000ff;">var</span> fibFromFile = edge.func(__dirname  + "/fib.cs"<span style="color: #000000;">);
</span><span style="color: #008080;">40</span> fibFromFile(5, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (error, result) {
</span><span style="color: #008080;">41</span>     <span style="color: #0000ff;">if</span><span style="color: #000000;"> (error) console.log(error);
</span><span style="color: #008080;">42</span> <span style="color: #000000;">    console.log(result);
</span><span style="color: #008080;">43</span> <span style="color: #000000;">});
</span><span style="color: #008080;">44</span> 
<span style="color: #008080;">45</span> <span style="color: #0000ff;">var</span> fibFromDll =<span style="color: #000000;"> edge.func({
</span><span style="color: #008080;">46</span>     assemblyFile: 'edge.demo.dll'<span style="color: #000000;">,
</span><span style="color: #008080;">47</span>     typeName: 'edge.demo.Startup'<span style="color: #000000;">,
</span><span style="color: #008080;">48</span>     methodName: 'Invoke'
<span style="color: #008080;">49</span> <span style="color: #000000;">});
</span><span style="color: #008080;">50</span> fibFromDll(5, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (error, result) {
</span><span style="color: #008080;">51</span>     <span style="color: #0000ff;">if</span><span style="color: #000000;"> (error) console.log(error);
</span><span style="color: #008080;">52</span> <span style="color: #000000;">    console.log(result);
</span><span style="color: #008080;">53</span> });</pre>
</div>

&nbsp;

效果:

[![image](http://images.cnitblog.com/blog/63184/201303/31010347-37d768d0e0e0441882aa1a34909245f9.png "image")](http://images.cnitblog.com/blog/63184/201303/31010346-272ac9bd26634985a6884e51c25a586e.png)

这里分为3类调用，直接源码嵌入node.js和文件外置，以后编译后的dll，多的不用说，其实很简单，如果你和一样同样喜欢js和.net的话。

在当下node.js刚兴起，成型的框架还不够多，或者有时我们必须以c或者c++来完成node.js的本地扩展的时候，edge.js给我们提供了另一个可选的途径就是 强大的.net大家族。

&nbsp;

<iframe src="http://tjanczuk.github.com/edge/#/" frameborder="0" width="100%" height="350"></iframe>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/03/31/2991200.html "原文首发")