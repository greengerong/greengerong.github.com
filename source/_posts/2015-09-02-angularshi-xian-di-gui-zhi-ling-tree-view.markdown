---
layout: post
title: "angular实现递归指令 - tree view"
date: 2015-09-02 07:47:21 +0800
comments: true
categories: [angular,javascript]
---
在层次数据结构展示中，树是一种极其常见的展现方式。比如系统中目录结构、企业组织结构、电子商务产品分类都是常见的树形结构数据。

这里我们采用Angular的方式来实现这类常见的tree view结构。

首先我们定义数据结构，采用以children属性来挂接子节点方式来展现树层次结构，示例如下：

	[
	   {
	      "id":"1",
	      "pid":"0",
	      "name":"家用电器",
	      "children":[
	         {
	            "id":"4",
	            "pid":"1",
	            "name":"大家电"
	         }
	      ]
	   },
	   {
	     ...
	   }
	   ...
	]

则我们对于ng way的tree view可以实现为：

JavaScript:
    
	angular.module('ng.demo', [])
	.directive('treeView',[function(){

		 return {
			  restrict: 'E',
			  templateUrl: '/treeView.html',
			  scope: {
				  treeData: '=',
				  canChecked: '=',
				  textField: '@',
				  itemClicked: '&',
				  itemCheckedChanged: '&',
				  itemTemplateUrl: '@'
			  },
			 controller:['$scope', function($scope){
				 $scope.itemExpended = function(item, $event){
					 item.$$isExpend = ! item.$$isExpend;
					 $event.stopPropagation();
				 };
				 
				 $scope.getItemIcon = function(item){
					 var isLeaf = $scope.isLeaf(item);
					 
					 if(isLeaf){
						 return 'fa fa-leaf';
					 }
					 
					 return item.$$isExpend ? 'fa fa-minus': 'fa fa-plus';	 
				 };
				 
				 $scope.isLeaf = function(item){
					return !item.children || !item.children.length; 
				 };
				 
				 $scope.warpCallback = function(callback, item, $event){
					  ($scope[callback] || angular.noop)({
						 $item:item,
						 $event:$event
					 });
				 };
			 }]
		 };
	 }]);


HTML:

树内容主题HTML： /treeView.html

	<ul class="tree-view">
	       <li ng-repeat="item in treeData" ng-include="'/treeItem.html'" ></li>
	</ul>

每个item节点的HTML：/treeItem.html

	<i ng-click="itemExpended(item, $event);" class="{{getItemIcon(item)}}"></i>

    <input type="checkbox" ng-model="item.$$isChecked" class="check-box" ng-if="canChecked" ng-change="warpCallback('itemCheckedChanged', item, $event)">

	<span class='text-field' ng-click="warpCallback('itemClicked', item, $event);">{{item[textField]}}</span>
	<ul ng-if="!isLeaf(item)" ng-show="item.$$isExpend">
	   <li ng-repeat="item in item.children" ng-include="'/treeItem.html'">
	   </li>
	</ul>

这里的技巧在于利用ng-include来加载子节点和数据，以及利用一个warpCallback方法来转接函数外部回调函数，利用angular.noop的空对象模式来避免未注册的回调场景。对于View交互的数据隔离采用了直接封装在元数据对象的方式，但它们都以$$开头，如$$isChecked、$$isExpend。在Angular程序中以$$开头的对象会被认为是内部的私有变量，在angular.toJson的时候，它们并不会被序列化，所以利用$http发回服务端更新的时候，它们并不会影响服务端传送的数据。同时，在客户端，我们也能利用对象的这些$$属性来控制View的状态，如item.$$isChecked来默认选中某一节点。

我们就可以如下方式来使用这个tree-view：

	<tree-view tree-data="demo.tree" text-field="name" value-field='id' item-clicked="demo.itemClicked($item)" item-checked-changed="demo.itemCheckedChanged($item)" can-checked="true"></tree-view>

效果如下，当然你也可以在[jsbin中体验它](http://jsbin.com/vefuqu/edit?html,js,output)：

 ![ng-tree-view](/images/blog_img/ng-tree-view-sample.png)