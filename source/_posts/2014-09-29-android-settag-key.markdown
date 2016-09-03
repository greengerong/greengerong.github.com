---
layout: post
title: "android setTag方法的key问题"
date: 2014-09-29 10:22:25 +0800
comments: true
categories: [android]
---
android在设计View类时，为了能储存一些辅助信息，设计一个一个setTag/getTag的方法。这让我想起在Winform设计中每个Control同样存在一个Tag。

今天要说的是我最近学习android遇见的setTag的坑。一般情况下我们只需要使用唯一参数的setTag方法。但有时我们需要存储多个数据，所以这个时候我们就需要使用带key的重载。


文档是描述：“ The specified key should be an id declared in the resources of the application to ensure it is unique (see the ID resource type). Keys identified as belonging to the Android framework or not associated with any package will cause an IllegalArgumentExceptionto be thrown.”


这里说明必须保证key的唯一，但是如果我们使用java常量定义key（private static final int TAG_ID = 1;）这样你任然会遇见如下错误：

	java.lang.IllegalArgumentException: The key must be an application-specific resource id

正确的解决方案是：

在res/values/strings.xml中定义这个key常量，如下：

		<resources>
			<item type="id" name="tag_first"></item>
			<item type="id" name="tag_second"></item>
		</resources>


使用如下：

		imageView.setTag(R.id.tag_first, "Hello");
		imageView.setTag(R.id.tag_second, "Success");