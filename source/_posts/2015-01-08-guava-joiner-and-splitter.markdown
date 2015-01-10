---
layout: post
title: "guava之Joiner 和 Splitter"
date: 2015-01-08 08:09:19 +0800
comments: true
categories: 
---
最近在给客户准备一个Guava的分享，所以会陆续的更新关于Guava更多的细节分享。本文将记录Guava中得字符串处理Joiner(连接)和Splitter(分割)处理。

##Joiner
首先我们来看看下面我们经常遇见的一个案例：

	题目：
	对于一个如下定义List

	   List<String> list =of("1", "2", null, “3”);

	按照’,’分割，并过滤掉null。

如果不用第三方库，如common-lange，Guava，用原生java，我们将怎么继续？

```java
	public static String join(List stringList, String delimiter) {    
	    StringBuilder builder = new StringBuilder();

	     for (Object item : stringList) { 
	        if (item != null) { 
	            builder
	             .append(item)
	             .append(delimiter); 
	         }
         }     

       builder.setLength(builder.length() delimiter.length());

	    return builder.toString(); 
	}
```

是不是很简单，但是繁琐，而且这里还有个坑，我们使用append的方式，子啊每次for完成后，我们必须去修正remove最后的分隔符：builder.setLength(builder.length() delimiter.length());

Guava版本呢？

```java
		public static String joinByGuava(List stringList, String delimiter) { 
		    return    Joiner
					   .on(delimiter)
					   .skipNulls()
					   .join(stringList);
		}
```

我们不在考虑更多的细节，并且很有语义的告诉代码的阅读者，用什么分隔符，需要过滤null值再join。

*note*:当然我们也可以用common-lange来很简单的完成：StringUtils.join(stringList, delimiter).但是个人推荐尽量使用Guava替代common-lange，因为Guava还有更多的有用方法，后续会陆续介绍，还有更有语义。

##Splitter


##MapJoinner和MapSplitter

对于MapJoinner和MapSplitter的最好案例就是url的param编码。

####MapJoinner

 	题目：
	生产一个查询id: 123,name: green的学生信息的url。

利用Guava的MapJoinner的代码如下：


```java

	Joiner.on("&").withKeyValueSeparator("=").join(ImmutableMap.of("id", "123", "name", "green"));

```

这里采用了on传入map item之间分隔符，以及withKeyValueSeparator传递map项key/value之间的分隔符。所以能够很简单的实现，不用我们在去实现一个的for循环代码。

####MapSplitter

    题目：
	对url中的查询字符串"id=123&name=green"进行分割

利用Guava的MapSplitter的代码如下：

```java
	final Map<String, String> join = Splitter.on("&").withKeyValueSeparator("=").split("id=123&name=green");
```

这里同样利用on传入字符串的第一分隔符，withKeyValueSeparator传入项的分隔符，产生map的key/value项，其结果是一个{id=123, name=green}的Map对象。





