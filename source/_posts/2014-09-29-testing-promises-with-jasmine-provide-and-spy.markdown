---
layout: post
title: "Jasmine测试ng Promises - Provide and Spy"
date: 2014-09-29 15:53:45 +0800
comments: true
categories: [angular,jasmine]
---
jasmine提供了很多些很实用的处理Promises的方法，首先我们来考虑下面的这个例子：

		angular.module("myApp.store").controller("StoresCtrl", function($scope, StoreService, Contact) {
		  StoreService.listStores().then(function(branches) {
		    Contact.retrieveContactInfo().then(function(userInfo) {
		        //more code here crossing user and stores data
		    });  
		  });
		});

下面让我们来尝试如何用angular提供的$provide创建一个依赖的实现，以及利用jasmine帮助我们fake方法的返回值：

代码如下，有详细注释帮助你去理解这段代码：


		describe("Store Controller", function() {
		  var $controller, Contact, StoreService, createController, scope;
		  
		  beforeEach(function() {
		    module('myApp.store');
		    
		    // Provide will help us create fake implementations for our dependencies
		    module(function($provide) {
		    
		      // Fake StoreService Implementation returning a promise
		      $provide.value('StoreService', {
		        listStores: function() {
		          return { 
		            then: function(callback) {return callback([{ some: "thing", hoursInfo: {isOpen: true}}]);}
		          };
		        },
		        chooseStore: function() { return null;}
		      });
		      
		      // Fake Contact Implementation return an empty object 
		      $provide.value('Contact', {
		        retrieveContactInfo: function() {
		          return {
		            then: function(callback) { return callback({});}
		          };
		        }
		      });
		      
		      return null;
		    });
		  });
		  
		  beforeEach(function() {
		  
		    // When Angular Injects the StoreService and Contact dependencies, 
		    // it will use the implementation we provided above
		    inject(function($controller, $rootScope, _StoreService_, _Contact_) {
		      scope = $rootScope.$new();
		      StoreService = _StoreService_;
		      Contact = _Contact_;
		      createController = function(params) {
		        return $controller("StoresCtrl", {
		          $scope: scope,
		          $stateParams: params || {}
		        });
		      };
		    });
		  });
		  
		  it("should call the store service to retrieve the store list", function() {
		    var user = { address: {street: 1}};
		    
		    // Jasmine spy over the listStores service. 
		    // Since we provided a fake response already we can just call through. 
		    spyOn(StoreService, 'listStores').and.callThrough();
		    
		    // Jasmine spy also allows to call Fake implementations via the callFake function 
		    // or we can return our own response via 'and.returnValue
		    // Here we can override the response we previously defined and return a promise with a user object
		    spyOn(Contact, 'retrieveContactInfo').and.callFake(function() {
		      return {
		        then: function(callback) { return callback(user); }
		      };
		    });
		    
		    createController();
		    // Since we setup a spy we can now expect that spied function to have been called 
		    // or to have been called with certain parameters..etc
		    expect(StoreService.listStores).toHaveBeenCalled();
		  });
		});


原文地址:[Testing Promises with Jasmine - Provide and Spy](http://ng-learn.org/2014/08/Testing_Promises_with_Jasmine_Provide_Spy/)