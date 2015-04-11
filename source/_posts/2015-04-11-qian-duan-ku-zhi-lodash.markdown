---
layout: post
title: "JavaScript工具库之Lodash"
date: 2015-04-11 14:53:27 +0800
comments: true
categories: [JavaScript]
---
你还在为JavaScript中的数据转换、匹配、查找等烦恼吗？一堆看似简单的foreach，却冗长无趣，可仍还在不停的repeat it！也许你已经用上了Underscore.js，不错，你已经进步很大一步了。然而今天我希望你能更进一步，利用lodash替换掉Underscore。

lodash一开始是Underscore.js库的一个fork，因为和其他(Underscore.js的)贡献者意见相左。John-David Dalton的最初目标，是提供更多“一致的跨浏览器行为……，并改善性能”。之后，该项目在现有成功的基础之上取得了更大的成果。最近lodash也发布了3.5版，成为了npm包仓库中依赖最多的库。它正在摆脱屌丝身份，成为开发者的常规选择之一。

现在我们所熟知的很多开源项目都已经使用或者转到了lodash阵营之上。比如JavaScript转译器Babel、博客平台Ghost，和项目脚手架工具Yeoman。特别Ghost是从Underscore迁移到了lodash，Ghost的创始人John O'Nolan对于此曾评价到：“这是一个非常明智的选择，它几乎完全是由我们开源开发社区推动的。我们发现lodash包含更多的功能，更好的性能、恰到好处地使用了semver，并且在Node.js社区（以及其他依赖）中越来越抢眼“。

##lodash演练
lodash主要使用了延迟计算，使得lodash其性能远远超过Underscore。在lodash中延迟计算意味着在我们的链式方法在显示或隐式的value()调用之前是不会执行的。由于这种执行的延后，因此lodash可以进行shortcut fusion这样的优化，通过合并链式iteratee大大降低迭代的次数。从而大大提供其执行性能。

百说不如一练，下面我们以用户信息为例：

	var users = [
	  { 'user': 'barney',  'age': 36 },
	  { 'user': 'fred',    'age': 40 },
	  { 'user': 'pebbles', 'age': 18 }
	];

####1. 获取所有用户名字，并以”，“分割

	var names = _.chain(users)
	  .map(function(user){
	    return user.user;
	  })
	  .join(" , ")
	  .value();
	console.log(names);

个人比较喜欢lodash延迟计算的现实value，以及JavaScript的函数式风格。在这里首先将users对象包装成为lodash对象，再map获取所有用户的名称，并最后利用join将用户名称以”，“连接在一起。注意这里只是一串方法链，如果你没有显样的调用value方法，使其立即执行的化，你将会得到如下的LodashWrapper延迟表达式：

	 LodashWrapper {__wrapped__: LazyWrapper, __actions__: Array[1], __chain__: true, constructor: function, after: function…}

 因为延迟表达式的存在，因此我们可以多次增加方法链，但这并不会被执行，所以不会存在性能的问题，最后知道我们需要使用的时候，使用value显式立即执行即可。

####2. 获取最年轻的用户

	 var youngest = _.chain(users)
	  .min(function(user){
	    return user.age;
	  })
	  .value();
	console.log(youngest);

这里利用了lodash提供的min函数可以轻易的解决。

在这里博主还希望用另外一个方式解释lodash方法链的优化,上面的方法可以等价为下面的方式，以age排序的第一个user：

	var youngest2 = _.chain(users)
	  .sortBy("age")
	  .map(function(user){
	    console.log("map", user);
	    return user;
	  })
	  .first()
	  .value();
	console.log(youngest2);

在这里博主多加了一个map作为log输出，如果你执行这行代码的时候，你会惊奇的看见这里只会有一个user的输出，这点可以证明在立即执行的时候lodash为我们的方法链做了可靠的优化；如果我们去掉first函数你则会看见有3个user对象的输出。

####3. 获取最年长的用户

	var oldest  = _.chain(users)
	  .max(function(user){
	    return user.age;
	  })
	  .value();

	console.log(oldest );

这里则使用lodash的max函数。

####4. 用户数组到用户Map的转换

在开发中我们经常会有把一堆素组形式的数据转换为Object形式的数组，便于根据属性key值查找，下面将以user对象来演示：

	var userObj = _.chain(users)
	  .map(function(user){
	    return [user.user, user.age];
	  })
	  .zipObject()
	  .value();
	console.log(userObj);

利用lodash首先将user数组map为[key, value]的数组集合，最后利用zipObject将结果转换为Object对象，zipObject会利用结果集的第一项作为key，第二项作为value生产Object。

##结尾

我们在这里展示知识lodash中很小一部分的API，正如随笔开始所说：lodash是为了提供更多“一致的跨浏览器行为……，并改善性能”API。所有的lodash API你可以在这里[https://lodash.com/docs#matches](https://lodash.com/docs#matches)查找。

本文的所演示的demo，你也可以在jsbin [http://jsbin.com/xocixubaru/1/edit?html,js,output](http://jsbin.com/xocixubaru/1/edit?html,js,output)演示。
