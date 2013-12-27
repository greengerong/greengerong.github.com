---
layout: post
title: "nodejs上HTML分析利器node-jquery"
description: "nodejs上HTML分析利器node-jquery"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;首先描述产生这篇随笔的场景：我需要获取项目在jenkins构建的最新Javascript Coverage显示在供管理层次查看的项目情况Report上，但是由于jenkins没有直接的API取得数据所需数据，所以我们只能从自建的容器发布Javascript Coverage数据API，供Report项目使用。

&nbsp;&nbsp;&nbsp;&nbsp; 由于采用简单的数据分析，只是Host一个简单的web Server,所以本人不喜欢Tomcat，IIS这类大型工具，显得有点杀鸡用牛刀，班门弄斧。我更喜欢node.js这类简易的web容器。所以项目采用node.js，并node.js天然的javascript与html操作的天然一体，借助DOM结构使得解析Html更容易，简洁。

&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;Node.js解析HTML DOM的当然是htmlpaser，jsdom。然而个人更喜欢jQuery的风格，与web jQuery的统一API,所以选择了node-jquery.其代码部署在Github的[https://github.com/coolaj86/node-jquery](https://github.com/coolaj86/node-jquery).

&nbsp; &nbsp;&nbsp;&nbsp;下面是本人写个一个简单demo：&nbsp; 抓取Github Popular project打印在控制台输出。

<div class="cnblogs_code">
<pre><span style="color: #008080;"> 1</span> <span style="color: #0000ff;">var</span> $ = require('jquery'<span style="color: #000000;">);
</span><span style="color: #008080;"> 2</span> 
<span style="color: #008080;"> 3</span>  
<span style="color: #008080;"> 4</span> 
<span style="color: #008080;"> 5</span> String.format = <span style="color: #0000ff;">function</span><span style="color: #000000;">() {
</span><span style="color: #008080;"> 6</span> 
<span style="color: #008080;"> 7</span>     <span style="color: #0000ff;">var</span> s = arguments[0<span style="color: #000000;">];
</span><span style="color: #008080;"> 8</span> 
<span style="color: #008080;"> 9</span>     <span style="color: #0000ff;">for</span> (<span style="color: #0000ff;">var</span> i = 0; i &lt; arguments.length - 1; i++<span style="color: #000000;">) {
</span><span style="color: #008080;">10</span> 
<span style="color: #008080;">11</span>         <span style="color: #0000ff;">var</span> reg = <span style="color: #0000ff;">new</span> RegExp("\\{" + i + "\\}", "gm"<span style="color: #000000;">);
</span><span style="color: #008080;">12</span> 
<span style="color: #008080;">13</span>         s = s.replace(reg, arguments[i + 1<span style="color: #000000;">]);
</span><span style="color: #008080;">14</span> 
<span style="color: #008080;">15</span> <span style="color: #000000;">    }
</span><span style="color: #008080;">16</span> 
<span style="color: #008080;">17</span>  
<span style="color: #008080;">18</span> 
<span style="color: #008080;">19</span>     <span style="color: #0000ff;">return</span><span style="color: #000000;"> s;
</span><span style="color: #008080;">20</span> 
<span style="color: #008080;">21</span> <span style="color: #000000;">};
</span><span style="color: #008080;">22</span> 
<span style="color: #008080;">23</span>  
<span style="color: #008080;">24</span> 
<span style="color: #008080;">25</span>  $.get("https://github.com/popular/forked",<span style="color: #0000ff;">function</span><span style="color: #000000;">(html){
</span><span style="color: #008080;">26</span> 
<span style="color: #008080;">27</span>  
<span style="color: #008080;">28</span> 
<span style="color: #008080;">29</span>         <span style="color: #0000ff;">var</span> $doc =<span style="color: #000000;"> $(html);
</span><span style="color: #008080;">30</span> 
<span style="color: #008080;">31</span>     console.log("No.  name  language  star   forks  "<span style="color: #000000;">)
</span><span style="color: #008080;">32</span> 
<span style="color: #008080;">33</span>         $doc.find("ul.repolist li.source").each(<span style="color: #0000ff;">function</span><span style="color: #000000;">(i,project){
</span><span style="color: #008080;">34</span> 
<span style="color: #008080;">35</span>  
<span style="color: #008080;">36</span> 
<span style="color: #008080;">37</span>         <span style="color: #0000ff;">var</span> $project =<span style="color: #000000;"> $(project);
</span><span style="color: #008080;">38</span> 
<span style="color: #008080;">39</span>                <span style="color: #0000ff;">var</span> name = $project.find("h3"<span style="color: #000000;">).text().trim();
</span><span style="color: #008080;">40</span> 
<span style="color: #008080;">41</span>                <span style="color: #0000ff;">var</span> language = $project.find("li:eq(0)"<span style="color: #000000;">).text().trim();
</span><span style="color: #008080;">42</span> 
<span style="color: #008080;">43</span>                <span style="color: #0000ff;">var</span> star = $project.find("li.stargazers"<span style="color: #000000;">).text().trim();
</span><span style="color: #008080;">44</span> 
<span style="color: #008080;">45</span>                <span style="color: #0000ff;">var</span> forks = $project.find("li.forks"<span style="color: #000000;">).text().trim();
</span><span style="color: #008080;">46</span> 
<span style="color: #008080;">47</span>                <span style="color: #0000ff;">var</span> row =String.format("{4} {0}  {1}  {2}  {3}"<span style="color: #000000;">,name,
</span><span style="color: #008080;">48</span> 
<span style="color: #008080;">49</span>                        language,star,forks,i + 1<span style="color: #000000;"> );
</span><span style="color: #008080;">50</span> 
<span style="color: #008080;">51</span>               
<span style="color: #008080;">52</span> 
<span style="color: #008080;">53</span> <span style="color: #000000;">               console.log(row);
</span><span style="color: #008080;">54</span> 
<span style="color: #008080;">55</span> <span style="color: #000000;">        });
</span><span style="color: #008080;">56</span> 
<span style="color: #008080;">57</span>  });</pre>
</div>

此项目寄宿在我Github [https://github.com/greengerong/node-jquery-demo](https://github.com/greengerong/node-jquery-demo)。仅供了解node-jquery学习demo，欢迎指教。

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/02/27/2935618.html "原文首发")