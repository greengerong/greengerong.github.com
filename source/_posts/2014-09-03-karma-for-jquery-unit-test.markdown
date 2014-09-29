---
layout: post
<<<<<<< HEAD
title: "karma for jQuery unit test"
date: 2014-09-03 13:37:33 +0800
comments: true
categories: 
---
=======
title: "karma作为jQuery单元测试Runner"
date: 2014-09-03 22:27:20 +0800
comments: true
categories: [karma,javascript,unit test]
---
karma作为angular测试runner出现，如果你使用过karma一定感受到这很不错的javascript测试runner。简单干净的配置文件karma.config.js，以及karma init一些快捷的配置command。以及整套测试套件，如html2js,coverage。对于angular单元测试karma就是一个全生态的测试套件，能够简洁快速的搭建整个测试流程。

本文将尝试运用karma作为jQuery单元测试runner。对于jQuery这种DOM操作的框架，有时难于分离view逻辑，以及ajax这种外部资源的mock，所以比较难于实施对jQuery程序的TDD开发。

####jasmime测试套件
对于jasmine测试框架为了解决这些问题有两个插件jasmine-jquery和jasmine-ajax。

####jasmine-jquery

jasmine-jQuery主要解决加载测试所需的DOM元素，为单元测试构建前置环境。jasmine-jQuery加载DOM方法：

	jasmine.getFixtures().fixturesPath = 'base path';
	loadFixtures('myfixture.html');
	jasmine.getFixtures().load(...);

这里的loadFixtures需要真实ajax获取html fixtures所以我们需要提前host html fixtures。jasmine-jQuery还框架了一些有用的matchers，如toBeChecked， toBeDisabled， toBeFocused，toBeInDOM......

####jasmine-ajax

jasmine-ajax则是对于一般ajax测试的mock框架，其从底层xmlhttprequest实施mock。所以让我们能偶很容易实施对于jQuery的$.ajax,$.get...mock。如

	 beforeEach(function() {
	    jasmine.Ajax.requests.when = function (url) {
	      return this.filter("/jquery/ajax")[0];
	    };
	    jasmine.Ajax.install();
  	});

  	it("jquery ajax success with getResponse", function() {
	    var result;

	    $.get("/jquery/ajax").success(function(data) {
 		 	result = data;
  		});

	    jasmine.Ajax.requests.when("/jquery/ajax").response({
	      "status": 200,
	      "contentType": 'text/plain',
	      "responseText": 'data from mock ajax'
	    });

    	expect(result).toEqual('data from mock ajax');
  	});


  	afterEach(function() {
    	jasmine.Ajax.uninstall();
  	});

对于jasmine-ajax是实施mock之前一定需要jasmine.Ajax.install()，以及测试完成后需要jasmine.Ajax.uninstall();jasmine-ajax在install后会把所有的ajax mock掉，所以如果有需要真实ajax的需要在install之前完成，如jasmine-jQuery加载view loadFixtures。

####运用karma runner

我们已经了解了jasmine测试的两个框架jasmine-jQuery和jasmine-ajax，所以运用karma作为runner，我们需要解决的问题就是把他们和karma集成在一起。

所以分为以下几步：
1：karma中引入jasmine-jQuery和jasmine-ajax(可以利用bowerinstall)
2：host 测试的html fixtures。
3：加载html fixtures 与install ajax之前。

对于host 文件karma提供了pattern模式，所以karma配置为：

	files: [
        {
          pattern: 'view/**/*.html',
          watched: true,
          included: false,
          served: true
        },
		'bower_components/jquery/dist/jquery.js',
        'bower_components/jasmine-jquery/lib/jasmine-jquery.js',
        'bower_components/jasmine-ajax/lib/mock-ajax.js',
        'src/*.js',
		'test/*.js'
    ],

这里需要注意karma自带的jasmine是低版本的，所以我们需要npm install karma-jasmine@2.0获取最新的karma-jasmine插件。

我们就可以完成了karma的配置，我们可以简单测试我们的配置：[demo on github](https://github.com/greengerong/karma-jasmine-jquery/).

测试html fixtures加载：

	describe('console html content', function() {

	  beforeEach(function() {
	    jasmine.getFixtures().fixturesPath = 'base/view/';
	    loadFixtures("index.html");
	  });

	  it('index html', function() {
	    expect($("h2")).toBeInDOM();
	    expect($("h2")).toContainText("this is index page");
	  });

	})

测试mock ajax：

	describe('console html content', function() {

	  beforeEach(function() {
	     jasmine.Ajax.requests.when = function(url) {
	         return this.filter("/jquery/ajax")[0];
	     };
	     jasmine.Ajax.install();
	 });


	  it('index html', function() {
	    expect($("h2")).toBeInDOM();
	    expect($("h2")).toContainText("this is index page");
	  });

	  it("ajax mock", function() {
	    var doneFn = jasmine.createSpy("success");

	    var xhr = new XMLHttpRequest();
	    xhr.onreadystatechange = function(args) {
	      if (this.readyState == this.DONE) {
	        doneFn(this.responseText);
	      }
	    };

	    xhr.open("GET", "/some/cool/url");
	    xhr.send();

	    expect(jasmine.Ajax.requests.mostRecent().url).toBe('/some/cool/url');
	    expect(doneFn).not.toHaveBeenCalled();

	    jasmine.Ajax.requests.mostRecent().response({
	      "status": 200,
	      "contentType": 'text/plain',
	      "responseText": 'awesome response'
	    });

	    expect(doneFn).toHaveBeenCalledWith('awesome response');
	  });

	  it("jquery ajax success with getResponse", function() {
	    var result;
	    getResponse().then(function(data){
	      result = data;
	    });

	    jasmine.Ajax.requests.when("/jquery/ajax").response({
	      "status": 200,
	      "contentType": 'text/plain',
	      "responseText": 'data from mock ajax'
	    });

	    expect(result).toEqual('data from mock ajax');
	  });

	  it("jquery ajax error", function() {
	    var status;
	    $.get("/jquery/ajax").error(function(response) {
	      status = response.status;
	    });

	    jasmine.Ajax.requests.when("/jquery/ajax").response({
	      "status": 400
	    });

	    expect(status).toEqual(400);
	  });

	  afterEach(function() {
	    jasmine.Ajax.uninstall();
	  });
	})		

更多请参见[demo on github](https://github.com/greengerong/karma-jasmine-jquery/).
>>>>>>> a2cb4ac8d999d161caa76a6fb4327023fefd38f5
