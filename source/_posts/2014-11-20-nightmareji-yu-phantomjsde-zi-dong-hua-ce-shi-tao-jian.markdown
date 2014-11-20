---
layout: post
title: "nightmare基于phantomjs的自动化测试套件"
date: 2014-11-20 18:58:15 +0800
comments: true
categories: [nightmare, phantomjs]
---(
今天将介绍一款自动化测试套件名叫nightmare，他是一个基于phantomjs的测试框架，一个基于phantomjs之上为测试应用封装的一套high level API。其API以goto, refresh, click, type...等简单的常用e2e测试动作封装，使得其语义清晰，简洁。其官方在[http://www.nightmarejs.org/](http://www.nightmarejs.org/).

如果你的项目测试不需要想需求和测试人员理解，那么基于nightmare测试或许是一个好的选择，你的降低测试代码的成本，以及测试套件的部署。我们可以选择基于jasmine-node等作为测试套件集成。

安装nightmare：

	npm install nightmare

下面我们对比与远程phantomjs的对比：

原phantomjs的代码：

	phantom.create(function (ph) {
	  ph.createPage(function (page) {
	    page.open('http://yahoo.com', function (status) {
	      page.evaluate(function () {
	        var el =
	          document.querySelector('input[title="Search"]');
	        el.value = 'github nightmare';
	      }, function (result) {
	        page.evaluate(function () {
	          var el = document.querySelector('.searchsubmit');
	          var event = document.createEvent('MouseEvent');
	          event.initEvent('click', true, false);
	          el.dispatchEvent(event);
	        }, function (result) {
	          ph.exit();
	        });
	      });
	    });
	  });
	});

nightmare代码：

	new Nightmare()
	  .goto('http://yahoo.com')
	  .type('input[title="Search"]', 'github nightmare')
	  .click('.searchsubmit')
	  .run();

一切显而易见，不用多说。

nightmare同时也支持插件方式抽取公用逻辑，以供复用和提高测试代码语气，如下例子：

	/**
	 * Login to a Swiftly account.
	 *
	 * @param {String} email
	 * @param {String} password
	 */

	exports.login = function(email, password){
	  return function(nightmare) {
	    nightmare
	      .viewport(800, 1600)
	      .goto('https://swiftly.com/login')
	        .type('#username', email)
	        .type('#password', password)
	        .click('.button--primary')
	      .wait();
	  };
	};

使用代码很简单：

	var Swiftly = require('nightmare-swiftly');
	new Nightmare()
	  .use(Swiftly.login(email, password))
	  .use(Swiftly.task(instructions, uploads, path))
	  .run();


