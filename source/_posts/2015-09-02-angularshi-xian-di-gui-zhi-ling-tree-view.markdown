---
layout: post
title: "angular实现递归指令-tree view"
date: 2015-09-02 07:47:21 +0800
comments: true
categories: [angular,javascript]
---
在层级结构数据展示中，树是一种极其常见的展现方式。比如系统中目录结构、企业组织结构、电子商务产品分类都是常见的树形结构数据。

这里我们采用更ng way来实现这类常见的tree view结构。

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
				  itemCheckedChanged: '&'
			  },
			 controller:['$scope', function($scope){
				 $scope.itemExpended = function(item, $event){
					 item.$$isExpend = ! item.$$isExpend;
					 $event.stopPropagation();
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


HTML:

树内容主题HTML： /treeView.html

	<ul class="tree-view">
	       <li ng-repeat="item in treeData" ng-include="'/treeItem.html'" ></li>
	</ul>

每个item节点的HTML：/treeItem.html

	<i ng-click="itemExpended(item, $event);" class="fa" 
	ng-class="{'fa-minus': !isLeaf(item)&& item.$$isExpend, 'fa-plus': !isLeaf(item)&&!item.$$isExpend, 'fa-leaf': isLeaf(item)}">
	</i>

	<input id="checkItem{{$index}}" type="checkbox" ng-model="item.$$isChecked" class="check-box" ng-if="canChecked" ng-change="warpCallback('itemCheckedChanged', item, $event)">

	<span class='text-field' ng-click="warpCallback('itemClicked', item, $event);">{{item[textField]}}</span>
	<ul ng-if="!isLeaf(item)" ng-show="item.$$isExpend">
	   <li ng-repeat="item in item.children" ng-include="'/treeItem.html'">
	   </li>
	</ul>

这里的技巧在于利用ng-include来加载子节点和数据，以及利用一个warpCallback方法来转接函数外部回调函数，利用angular.noop的空对象模式来避免未注册的回调场景。

我们就可以如下方式来使用这个tree-view：

	<tree-view tree-data="demo.tree" text-field="name" value-field='id' item-clicked="demo.itemClicked($item)" item-checked-changed="demo.itemCheckedChanged($item)" can-checked="true"></tree-view>

效果如下，当然你也可以在[jsbin中体验它](http://jsbin.com/vefuqu/edit?html,js,output)：

 ![ng-tree-view](/images/blog_img/ng-tree-view-sample.png)