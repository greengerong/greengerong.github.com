---
layout: post
title: "JavaScript 函数replace揭秘"
description: "JavaScript 函数replace揭秘"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;在JavaScript中replace函数作为字符串替换函数，这是一个威力强大的字符串操作函数，对于常见字符串操作的推荐用法。这篇随笔就来更加深入的理解它。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; replace函数接受两个参数,第一个参数为字符串或正则表达式，第一个参数同样可以接受一个字符串，还可能是一个函数。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 首先对于第一个参数为字符串的我们不再需要多说"I am a boy".replace("boy","girl"),输出："I am a girl"。在这里想说的是第一个参数为正则的情形。对于正则表达式来说首先会根据是否全局的（全局//g）决定替换行为，如果是全部的则替换全部替换，非全局的只有替换首个匹配的字符串。例如：

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;gutter:false;">"Ha Ha".replace(/\b\w+\b/g, "He")  // He He

"Ha Ha".replace(/\b\w+\b/, "He")  //He Ha
</pre>
</div>

1:第二个参数为字符串：

&nbsp;&nbsp;&nbsp; 对于正则replace约定了一个特殊标记符$：

1.  $i (i:1-99) : 表示从左到右正则子表达式所匹配的文本。
2.  $&amp;:表示与正则表达式匹配的全文本。
3.  $`(`:切换技能键)：表示匹配字符串的左边文本。
4.  $&rsquo;(&lsquo;:单引号)：表示匹配字符串的右边文本。
5.  $$：表示$转移。

下面来几个demo:

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;gutter:false;">"boy &amp; girl".replace(/(\w+)\s*&amp;\s*(\w+)/g,"$2 &amp; $1") //girl &amp; boy

"boy".replace(/\w+/g,"$&amp;-$&amp;") // boy-boy

"javascript".replace(/script/,"$&amp; != $`") //javascript != java

"javascript".replace(/java/,"$&amp;$' is ") // javascript is script
</pre>
</div>

2：第二个参数为函数：

&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;在ECMAScript3推荐使用函数方式，实现于JavaScript1.2.当replace方法执行的时候每次都会调用该函数，返回值作为替换的新值。

&nbsp;&nbsp;&nbsp;&nbsp; 函数参数的规定：

1.  第一个参数为每次匹配的全文本（$&amp;）。
2.  中间参数为子表达式匹配字符串，个数不限.( $i (i:1-99))
3.  倒数第二个参数为匹配文本字符串的匹配下标位置。
4.  最后一个参数表示字符串本身。

这就是本文所要说replace威力强大的地方，理论的东西都是干货，我们需要示例解决一切空洞的问题：

1：字符串首字母大写：

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;gutter:false;">String.prototype.capitalize = function(){

    return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase();

    } );

};
</pre>
</div>

console.log("i am a boy !".capitalize())

输出：I Am A Boy !

2:对字符串&ldquo;张三56分， 李四74分， 王五92分， 赵六84分&rdquo;的分数提取汇总，算出平均分并输出每个人的平均分差距。

<div class="cnblogs_Highlighter">
<pre class="brush:javascript;gutter:false;">var s = "张三56分， 李四74分， 王五92分， 赵六84分";

var a = s.match(/\d+/g);

var sum = 0;

for(var i = 0 ; i &lt; a.length; i++){

            sum += parseFloat(a[i]);

}

var avg = sum / a.length;

function f(){

            var n = parseFloat(arguments[1]);

            return n + "分" + "(" + ((n &gt; avg) ? ("超出平均分" + (n - avg)) :

                        ("低于平均分" + (avg - n))) + "分)";

}

var result = s.replace(/(\d+)分/g, f);

console.log(result);
</pre>
</div>

&nbsp;

输出：

张三56分(低于平均分20.5分)， 李四74分(低于平均分2.5分)， 王五92分(超出平均分15.5分)， 赵六84分(超出平均分7.5分)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JavaScript的replace函数再加上正则的高级应用，JavaScript的replace将会发回更大的威力所在，在这里将不再深入正则高级应用断言之类的。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/03/14/2958720.html "原文首发")