---
layout: post
title: "jQuery之筛选函数"
description: "jQuery之筛选函数"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; jQuery的筛选函数提供了串联、查找和过滤函数，为我们的jQuery对象操作带来了很多的方便，今天我们就来温习下jQuery带来的这些筛选函数。

* * *

## 1：串联函数：

* * *

（1）：andSelf()

return：jQuery；

explain：

加入先前所选的加入当前元素中

对于筛选或查找后的元素，要加入先前所选元素时将会很有用。

test：

&lt;div&gt;&lt;p&gt;test&lt;/p&gt;&lt;/div&gt;

example：

$(&#8220;div&#8221;).find(&#8220;p&#8221;).andSelf().addClass(&#8220;class1&#8221;);

result：

&lt;div&gt;&lt;p class=&#8221;class1&#8221;&gt;test&lt;/p&gt;&lt;/div&gt;

* * *

(2):end()

return :jQuery;

explain:

回到最近的一个"破坏性"操作之前。即，将匹配的元素列表变为前一次的状态。

如果之前没有破坏性操作，则返回一个空集。所谓的"破坏性"就是指任何改变所匹配的jQuery元素的操作。这包括在 Traversing 中任何返回一个jQuery对象的函数--'add', 'andSelf', 'children', 'filter', 'find', 'map', 'next', 'nextAll', 'not', 'parent', 'parents', 'prev', 'prevAll', 'siblings' and 'slice'--再加上 Manipulation 中的 'clone'。

test:

&lt;div&gt;&lt;p&gt;test&lt;/p&gt;&lt;/div&gt;

example:

$(&#8220;div&#8221;).find(&#8220;p&#8221;).end();

//$(&#8220;div&#8221;).find(&#8220;p&#8221;)：&lt;p&gt;test&lt;/p&gt;

result:&lt;div&gt;&lt;p&gt;test&lt;/p&gt;&lt;/div&gt;

* * *

## 2:查找函数:

* * *

(1):add(exp);

return :jQuery;

explain:

把与表达式匹配的元素添加到jQuery对象中。这个函数可以用于连接分别与两个表达式匹配的元素结果集。

test:

&lt;p&gt;test1&lt;/p&gt;&lt;a&gt;test2&lt;/a&gt;

example：

$(&#8220;p&#8221;).add(&#8220;a&#8221;);

result:

[&lt;p&gt;test1&lt;/p&gt;,&lt;a&gt;test2&lt;/a&gt;]//数组

* * *

(2):children([expr]);

return:jQuery

explain:

取得一个包含匹配的元素集合中每一个元素的所有子元素的元素集合。

可以通过可选的表达式来过滤所匹配的子元素。注意：parents()将查找所有祖辈元素，而children()之考虑子元素而不考虑所有后代元素。

test:

&lt;div&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/div&gt;

example:

$(&#8220;div&#8221;).children();

result:&lt;span&gt;Hello Again&lt;/span&gt;

* * *

(3):find(expr)

return:jquery

explain:

搜索所有与指定表达式匹配的元素。这个函数是找出正在处理的元素的后代元素的好方法。

所有搜索都依靠jQuery表达式来完成。这个表达式可以使用CSS1-3的选择器语法来写。

test:

&lt;p&gt;&lt;span&gt;Hello&lt;/span&gt;, how are you?&lt;/p&gt;

example:

$("p").find("span");

result:&lt;span&gt;Hello&lt;/span&gt;

* * *

(4):next([expr])

return :jquery

explain:

取得一个包含匹配的元素集合中每一个元素紧邻的后面同辈元素的元素集合。

这个函数只返回后面那个紧邻的同辈元素，而不是后面所有的同辈元素（可以使用nextAll）。可以用一个可选的表达式进行筛选。

test:

&lt;p&gt;&lt;span&gt;Hello&lt;/span&gt;&lt;a&gt;h1&lt;/a&gt;&lt;/p&gt;;

example:

$(&#8220;span&#8221;).next();

result:&lt;a&gt;h1&lt;/a&gt;;

&nbsp;

* * *

&nbsp;

(5):nextAll([expr])

return:jQuery

explain:查找当前元素之后所有的同辈元素。

test:&lt;div&gt;h1&lt;/div&gt;&lt;div&gt;h2&lt;/div&gt;&lt;div&gt;h3&lt;/div&gt;;

example:

$(&#8220;div:first&#8221;).nextAll();

result:&lt;div&gt;h2&lt;div&gt;,&lt;div&gt;h3&lt;/div&gt;;:

&nbsp;

* * *

(6):offsetParent() 

&nbsp;

return :jQuery

explain:

返回第一个匹配元素用于定位的父节点。

这返回父元素中第一个其position设为relative或者absolute的元素。此方法仅对可见元素有效。

&nbsp;

* * *

(7):parent([expr]) 

&nbsp;

return:jQuery

explain:

取得一个包含着所有匹配元素的唯一父元素的元素集合。

你可以使用可选的表达式来筛选。

test:

&lt;div&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;/div&gt;

example:

$(&#8220;p&#8221;).parent();

result:&lt;div&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;/div&gt;;

&nbsp;

* * *

(8):parents([expr]) 

&nbsp;

return:jquery;

explain:取得一个包含着所有匹配元素的祖先元素的元素集合（不包含根元素）。

test:

&lt;body&gt;&lt;div&gt;&lt;p&gt;&lt;span&gt;Hello&lt;/span&gt;&lt;/p&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/div&gt;&lt;/body&gt;

example:$(&#8220;span&#8221;).parents(&#8220;p&#8221;);

result:&lt;p&gt;&lt;span&gt;&lt;Hello&gt;&lt;/span&gt;&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(9):prev([expr])

return:jquery

explain:

取得一个包含匹配的元素集合中每一个元素紧邻的前一个同辈元素的元素集合。

可以用一个可选的表达式进行筛选。只有紧邻的同辈元素会被匹配到，而不是前面所有的同辈元素。

test:

&lt;div&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/div&gt;&lt;p&gt;And Again&lt;/p&gt;

example:

$(&#8220;p&#8221;).prev();

result:&lt;div&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/div&gt;;

&nbsp;

* * *

&nbsp;

(9):prevAll([expr])

return:jQuery

explain:

查找当前元素之前所有的同辈元素;

test:

&lt;div&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;

example:

$(&#8220;div:last&#8221;).prevAll();

result:&lt;div&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;

&nbsp;

* * *

&nbsp;

(10):siblings([expr])

return :jquery

explain:

取得一个包含匹配的元素集合中每一个元素的所有唯一同辈元素的元素集合。

test:

&lt;p&gt;Hello&lt;/p&gt;&lt;div&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/div&gt;&lt;p&gt;And Again&lt;/p&gt;

example:$("div").siblings()

result:

[ &lt;p&gt;Hello&lt;/p&gt;, &lt;p&gt;And Again&lt;/p&gt; ]

&nbsp;

* * *

&nbsp;

## 3:过滤函数：

* * *

(1):eq(insex);

return:jQuery

explain:获取第N个元素.这个元素的位置是从0算起。

test:&lt;p&gt; This is just a test.&lt;/p&gt; &lt;p&gt; So is this&lt;/p&gt;

example:$(&#8220;p&#8221;).eq(1);

result:&lt;p&gt; So is this&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(2):filter(expr)

return:jQuery

explain:

筛选出与指定表达式匹配的元素集合。

这个方法用于缩小匹配的范围。用逗号分隔多个表达式

test:

&lt;p&gt;Hello&lt;/p&gt;&lt;p&gt;Hello Again&lt;/p&gt;&lt;p class="selected"&gt;And Again&lt;/p&gt;

example:

$("p").filter(".selected");

result:

&lt;p class="selected"&gt;And Again&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(3):filter(fn)

return:jquery

explain:

筛选出与指定函数返回值匹配的元素集合

test:

&lt;p&gt;&lt;ol&gt;&lt;li&gt;Hello&lt;/li&gt;&lt;/ol&gt;&lt;/p&gt;&lt;p&gt;How are you?&lt;/p&gt;

example:

$("p").filter(function(index) { 
&nbsp; return $("ol", this).length == 0; 
});

result:

&lt;p&gt;How are you?&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(4):hasClass(class)

return:jQuery

explain:

检查当前的元素是否含有某个特定的类，如果有，则返回true。这其实就是 is("." + class)。

test:

&lt;div class="protected"&gt;&lt;/div&gt;&lt;div&gt;&lt;/div&gt;

example:

$(&#8220;div&#8221;).hasClass("protected")

result:

true

&nbsp;

&nbsp;

* * *

&nbsp;

(5):is(expr)

return:jquery

explain:

用一个表达式来检查当前选择的元素集合，如果其中至少有一个元素符合这个给定的表达式就返回true。

test:

&lt;form&gt;&lt;input type="checkbox" /&gt;&lt;/form&gt;

explam:

$("input[type='checkbox']").parent().is("form")

result:

true;

&nbsp;

&nbsp;

* * *

&nbsp;

(6):map(callback)

return:jQuery

explain:

将一组元素转换成其他数组（不论是否是元素数组);

test:

&lt;p&gt;&lt;b&gt;Values: &lt;/b&gt;&lt;/p&gt; 
&lt;form&gt; 
&nbsp; &lt;input type="text" name="name" value="John"/&gt; 
&nbsp; &lt;input type="text" name="password" value="password"/&gt; 
&nbsp; &lt;input type="text" name="url" value="http://ejohn.org/"/&gt; 
&lt;/form&gt;

explam:

$("p").append( $("input").map(function(){ 
&nbsp; return $(this).val(); 
}).get().join(", ") );

result:

&lt;p&gt;John, password, http://ejohn.org/&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(7):not(expr)

return:jQuery

explain:

删除与指定表达式匹配的元素

test:

&lt;p&gt;Hello&lt;/p&gt;&lt;p id="selected"&gt;Hello Again&lt;/p&gt;

example:

$("p").not( $("#selected")[0] )

result:

&lt;p&gt;Hello&lt;/p&gt;

&nbsp;

* * *

&nbsp;

(8):slice(start,[end])

return:jQuery

explain:

选取一个匹配的子集;

test:

&lt;p&gt;Hello&lt;/p&gt;&lt;p&gt;cruel&lt;/p&gt;&lt;p&gt;World&lt;/p&gt;

example:

$("p").slice(0, 1).wrapInner("&lt;b&gt;&lt;/b&gt;");

result:

&lt;p&gt;&lt;b&gt;Hello&lt;/b&gt;&lt;/p&gt;

&nbsp;

* * *

&nbsp;本博客中同类文章还有，请见：[<font color="#6699cc">我jQuery系列之目录汇总</font>](http://www.cnblogs.com/whitewolf/archive/2010/06/09/1754988.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/05/01/1725700.html "原文首发")