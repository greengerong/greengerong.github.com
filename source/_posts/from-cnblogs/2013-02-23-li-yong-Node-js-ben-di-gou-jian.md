---
layout: post
title: "利用Node.js本地构建"
description: "利用Node.js本地构建"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; Node.js是一个基于Google Chrome浏览器v8 javascript执行引擎的异步I/O事件驱动的运行平台。直从2009年诞生开始，已经在业界得到了很多的关注，在这里也必要多说，如果你还不清楚的，请移步到[Node官网](http://nodejs.org/)。

在这里我们要讲的是用Node.js来构建本地Build。构建本地Build，我们已经有很多选择，如Ant，Maven，Gradle等。为什么我们还需要Node.js？对于我们的开发中会有一些小的基本自动化构建，如文件的监控(Less编译)，javascript的压缩，不稳定集成服务代理，快速的集成反馈，文件的迁移&hellip;而对于项目来说我并不像引入太多的技术债, Node.js所使用的javascript是做web项目开发的一门必备技能，javascript作为一门比较容易入门语言，直从第一次接触Node.js，我爱不释手，由于我对Javascript基础，能够快速使用它，并不需要付出更多的学习成本，而且我感觉在服务端和客户端用同一种语言，在能一定代码重用妙不可言。而且Node.js提供了内置的web服务器，简单的文件监听，事件机制等也为做本地Build提供了很好的条件。

1：文件监听

<div class="cnblogs_code" onclick="cnblogs_code_show('cbcdb5ce-a6b4-490b-b6ad-fb4a4bf03481')">
<div id="cnblogs_code_open_cbcdb5ce-a6b4-490b-b6ad-fb4a4bf03481" class="cnblogs_code_hide">
<pre><span style="color: #008080;">  1</span> <span style="color: #0000ff;">var</span> fs = require("fs"<span style="color: #000000;">);
</span><span style="color: #008080;">  2</span> 
<span style="color: #008080;">  3</span> <span style="color: #0000ff;">var</span> exec = require('child_process'<span style="color: #000000;">).exec
</span><span style="color: #008080;">  4</span> 
<span style="color: #008080;">  5</span> <span style="color: #0000ff;">var</span> underscore = require("underscore"<span style="color: #000000;">);
</span><span style="color: #008080;">  6</span> 
<span style="color: #008080;">  7</span> <span style="color: #0000ff;">var</span> configs =<span style="color: #000000;"> [
</span><span style="color: #008080;">  8</span> 
<span style="color: #008080;">  9</span>     {file:/.*\.less/g, command:" dotless.Compiler.exe style.less style.css"<span style="color: #000000;">}
</span><span style="color: #008080;"> 10</span> 
<span style="color: #008080;"> 11</span> <span style="color: #000000;">];
</span><span style="color: #008080;"> 12</span> 
<span style="color: #008080;"> 13</span> <span style="color: #0000ff;">var</span> source = "E:\\Project\\xxx\\style"<span style="color: #000000;">;
</span><span style="color: #008080;"> 14</span> 
<span style="color: #008080;"> 15</span>  
<span style="color: #008080;"> 16</span> 
<span style="color: #008080;"> 17</span> String.format = <span style="color: #0000ff;">function</span><span style="color: #000000;"> () {
</span><span style="color: #008080;"> 18</span> 
<span style="color: #008080;"> 19</span>     <span style="color: #0000ff;">var</span> s = arguments[0<span style="color: #000000;">];
</span><span style="color: #008080;"> 20</span> 
<span style="color: #008080;"> 21</span>     <span style="color: #0000ff;">for</span> (<span style="color: #0000ff;">var</span> i = 0; i &lt; arguments.length - 1; i++<span style="color: #000000;">) {
</span><span style="color: #008080;"> 22</span> 
<span style="color: #008080;"> 23</span>         <span style="color: #0000ff;">var</span> reg = <span style="color: #0000ff;">new</span> RegExp("\\{" + i + "\\}", "gm"<span style="color: #000000;">);
</span><span style="color: #008080;"> 24</span> 
<span style="color: #008080;"> 25</span>         s = s.replace(reg, arguments[i + 1<span style="color: #000000;">]);
</span><span style="color: #008080;"> 26</span> 
<span style="color: #008080;"> 27</span> <span style="color: #000000;">    }
</span><span style="color: #008080;"> 28</span> 
<span style="color: #008080;"> 29</span>  
<span style="color: #008080;"> 30</span> 
<span style="color: #008080;"> 31</span>     <span style="color: #0000ff;">return</span><span style="color: #000000;"> s;
</span><span style="color: #008080;"> 32</span> 
<span style="color: #008080;"> 33</span> <span style="color: #000000;">};
</span><span style="color: #008080;"> 34</span> 
<span style="color: #008080;"> 35</span>  
<span style="color: #008080;"> 36</span> 
<span style="color: #008080;"> 37</span> (<span style="color: #0000ff;">function</span><span style="color: #000000;"> (fs, exec, underscore) {
</span><span style="color: #008080;"> 38</span> 
<span style="color: #008080;"> 39</span>     <span style="color: #0000ff;">var</span> readFiles = <span style="color: #0000ff;">function</span><span style="color: #000000;"> (dir, done) {
</span><span style="color: #008080;"> 40</span> 
<span style="color: #008080;"> 41</span>         <span style="color: #0000ff;">var</span> results =<span style="color: #000000;"> [];
</span><span style="color: #008080;"> 42</span> 
<span style="color: #008080;"> 43</span>         fs.readdir(dir, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (err, list) {
</span><span style="color: #008080;"> 44</span> 
<span style="color: #008080;"> 45</span>             <span style="color: #0000ff;">if</span> (err) <span style="color: #0000ff;">return</span><span style="color: #000000;"> done(err);
</span><span style="color: #008080;"> 46</span> 
<span style="color: #008080;"> 47</span>             <span style="color: #0000ff;">var</span> pending =<span style="color: #000000;"> list.length;
</span><span style="color: #008080;"> 48</span> 
<span style="color: #008080;"> 49</span>             <span style="color: #0000ff;">if</span> (!pending) <span style="color: #0000ff;">return</span> done(<span style="color: #0000ff;">null</span><span style="color: #000000;">, results);
</span><span style="color: #008080;"> 50</span> 
<span style="color: #008080;"> 51</span>             list.forEach(<span style="color: #0000ff;">function</span><span style="color: #000000;"> (file) {
</span><span style="color: #008080;"> 52</span> 
<span style="color: #008080;"> 53</span>                 file = dir + '/' +<span style="color: #000000;"> file;
</span><span style="color: #008080;"> 54</span> 
<span style="color: #008080;"> 55</span>                 fs.stat(file, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (err, stat) {
</span><span style="color: #008080;"> 56</span> 
<span style="color: #008080;"> 57</span>                     <span style="color: #0000ff;">if</span> (stat &amp;&amp;<span style="color: #000000;"> stat.isDirectory()) {
</span><span style="color: #008080;"> 58</span> 
<span style="color: #008080;"> 59</span>                         readFiles(file, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (err, res) {
</span><span style="color: #008080;"> 60</span> 
<span style="color: #008080;"> 61</span>                             results =<span style="color: #000000;"> results.concat(res);
</span><span style="color: #008080;"> 62</span> 
<span style="color: #008080;"> 63</span>                             <span style="color: #0000ff;">if</span> (!--pending) done(<span style="color: #0000ff;">null</span><span style="color: #000000;">, results);
</span><span style="color: #008080;"> 64</span> 
<span style="color: #008080;"> 65</span> <span style="color: #000000;">                        });
</span><span style="color: #008080;"> 66</span> 
<span style="color: #008080;"> 67</span>                     } <span style="color: #0000ff;">else</span><span style="color: #000000;"> {
</span><span style="color: #008080;"> 68</span> 
<span style="color: #008080;"> 69</span> <span style="color: #000000;">                        results.push(file);
</span><span style="color: #008080;"> 70</span> 
<span style="color: #008080;"> 71</span>                         <span style="color: #0000ff;">if</span> (!--pending) done(<span style="color: #0000ff;">null</span><span style="color: #000000;">, results);
</span><span style="color: #008080;"> 72</span> 
<span style="color: #008080;"> 73</span> <span style="color: #000000;">                    }
</span><span style="color: #008080;"> 74</span> 
<span style="color: #008080;"> 75</span> <span style="color: #000000;">                });
</span><span style="color: #008080;"> 76</span> 
<span style="color: #008080;"> 77</span> <span style="color: #000000;">            });
</span><span style="color: #008080;"> 78</span> 
<span style="color: #008080;"> 79</span> <span style="color: #000000;">        });
</span><span style="color: #008080;"> 80</span> 
<span style="color: #008080;"> 81</span> <span style="color: #000000;">    };
</span><span style="color: #008080;"> 82</span> 
<span style="color: #008080;"> 83</span>     <span style="color: #0000ff;">var</span> start = <span style="color: #0000ff;">function</span><span style="color: #000000;"> (source, configs) {
</span><span style="color: #008080;"> 84</span> 
<span style="color: #008080;"> 85</span>         <span style="color: #0000ff;">var</span> watch = <span style="color: #0000ff;">function</span><span style="color: #000000;"> (error, list) {
</span><span style="color: #008080;"> 86</span> 
<span style="color: #008080;"> 87</span>             configs.forEach(<span style="color: #0000ff;">function</span><span style="color: #000000;"> (cmd) {
</span><span style="color: #008080;"> 88</span> 
<span style="color: #008080;"> 89</span>                 <span style="color: #0000ff;">var</span> files = underscore.filter(list, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (n) {
</span><span style="color: #008080;"> 90</span> 
<span style="color: #008080;"> 91</span>                     <span style="color: #0000ff;">return</span><span style="color: #000000;"> n.match(cmd.file);
</span><span style="color: #008080;"> 92</span> 
<span style="color: #008080;"> 93</span> <span style="color: #000000;">                });
</span><span style="color: #008080;"> 94</span> 
<span style="color: #008080;"> 95</span>                 files.forEach(<span style="color: #0000ff;">function</span><span style="color: #000000;"> (file) {
</span><span style="color: #008080;"> 96</span> 
<span style="color: #008080;"> 97</span>                     fs.watch(file, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (oper, f) {
</span><span style="color: #008080;"> 98</span> 
<span style="color: #008080;"> 99</span>                         <span style="color: #0000ff;">var</span> changeCommand =<span style="color: #000000;"> String.format(cmd.command, f);
</span><span style="color: #008080;">100</span> 
<span style="color: #008080;">101</span>                         console.log(String.format("{0} changed,command '{1}' execute..."<span style="color: #000000;">, f, changeCommand));
</span><span style="color: #008080;">102</span> 
<span style="color: #008080;">103</span>                         exec(changeCommand, <span style="color: #0000ff;">function</span><span style="color: #000000;"> (err, stdout, stderr) {
</span><span style="color: #008080;">104</span> 
<span style="color: #008080;">105</span>                             console.log(err ?<span style="color: #000000;"> stderr : stdout);
</span><span style="color: #008080;">106</span> 
<span style="color: #008080;">107</span> <span style="color: #000000;">                        });
</span><span style="color: #008080;">108</span> 
<span style="color: #008080;">109</span> <span style="color: #000000;">                    });
</span><span style="color: #008080;">110</span> 
<span style="color: #008080;">111</span> <span style="color: #000000;">                });
</span><span style="color: #008080;">112</span> 
<span style="color: #008080;">113</span>  
<span style="color: #008080;">114</span> 
<span style="color: #008080;">115</span> <span style="color: #000000;">            });
</span><span style="color: #008080;">116</span> 
<span style="color: #008080;">117</span> <span style="color: #000000;">        };
</span><span style="color: #008080;">118</span> 
<span style="color: #008080;">119</span> <span style="color: #000000;">        readFiles(source, watch);
</span><span style="color: #008080;">120</span> 
<span style="color: #008080;">121</span> <span style="color: #000000;">    };
</span><span style="color: #008080;">122</span> 
<span style="color: #008080;">123</span>     <span style="color: #0000ff;">return</span><span style="color: #000000;"> {start:start};
</span><span style="color: #008080;">124</span> 
<span style="color: #008080;">125</span> })(fs, exec, underscore).start(source, configs);</pre>
</div>
</div>

在这里提供的示例是Less的编译，虽然Less本也提供了Node的编译工具和[watchr](https://github.com/mynyml/watchr)监听工具,但是在项目中我会监听Less文件，却只有编译几个固定的Less引导文件。同样我们可以根据不同的文件执行不同的命令实现一些自动化。如：.js文件的同步到测试目录。

2：文件的合并

如果你用jasmine运行你的Javascript测试，你需要吧js文件的测试文件引入到runner head中，我一直很懒，喜欢一键搞定的感觉。利用node.js的模板引擎。

&nbsp;&nbsp; 3：javascript 产品包压缩

<div class="cnblogs_code" onclick="cnblogs_code_show('ce19c67c-3081-44fa-8bb8-7296297268c8')">
<div id="cnblogs_code_open_ce19c67c-3081-44fa-8bb8-7296297268c8" class="cnblogs_code_hide">
<pre><span style="color: #008080;"> 1</span> <span style="color: #0000ff;">var</span> FILE_ENCODING = <span style="color: #800000;">'</span><span style="color: #800000;">utf-8</span><span style="color: #800000;">'</span><span style="color: #000000;">;
</span><span style="color: #008080;"> 2</span> 
<span style="color: #008080;"> 3</span> <span style="color: #000000;">function uglify(srcPath, jsMinPath) {
</span><span style="color: #008080;"> 4</span> 
<span style="color: #008080;"> 5</span>     <span style="color: #0000ff;">var</span> uglyfyJS = require(<span style="color: #800000;">'</span><span style="color: #800000;">uglify-js</span><span style="color: #800000;">'</span><span style="color: #000000;">),
</span><span style="color: #008080;"> 6</span> 
<span style="color: #008080;"> 7</span>        jsp =<span style="color: #000000;"> uglyfyJS.parser,
</span><span style="color: #008080;"> 8</span> 
<span style="color: #008080;"> 9</span>        pro =<span style="color: #000000;"> uglyfyJS.uglify,
</span><span style="color: #008080;">10</span> 
<span style="color: #008080;">11</span>        ast =<span style="color: #000000;"> jsp.parse( _fs.readFileSync(srcPath, FILE_ENCODING) );
</span><span style="color: #008080;">12</span> 
<span style="color: #008080;">13</span>  
<span style="color: #008080;">14</span> 
<span style="color: #008080;">15</span>       ast =<span style="color: #000000;"> pro.ast_mangle(ast);
</span><span style="color: #008080;">16</span> 
<span style="color: #008080;">17</span>       ast =<span style="color: #000000;"> pro.ast_a squeeze(ast);
</span><span style="color: #008080;">18</span> 
<span style="color: #008080;">19</span> <span style="color: #000000;">      _fs.writeFileSync(jsMinPath, pro.gen_code(ast), FILE_ENCODING);
</span><span style="color: #008080;">20</span> 
<span style="color: #008080;">21</span>     console.log(<span style="color: #800000;">'</span> <span style="color: #800000;">'</span>+ jsMinPath +<span style="color: #800000;">'</span><span style="color: #800000;">完成.</span><span style="color: #800000;">'</span><span style="color: #000000;">);
</span><span style="color: #008080;">22</span> 
<span style="color: #008080;">23</span> <span style="color: #000000;">}
</span><span style="color: #008080;">24</span> 
<span style="color: #008080;">25</span> uglify(js/test.js<span style="color: #800000;">'</span><span style="color: #800000;">, js/test.min.js</span><span style="color: #800000;">'</span>);</pre>
</div>
</div>

我们可以尽力发挥自己的想象，如本地Build自动运行，快速集成快速反馈；代理服务器，处理不稳定服务的集成，带来稳定的开发，比如testacluar就是根据node.js能够很容易的构建web服务器，从jstd转过来的javascript test和coverage插件。。。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/02/23/2923862.html "原文首发")