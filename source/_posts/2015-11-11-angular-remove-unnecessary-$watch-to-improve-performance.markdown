---
layout: post
title: "Angular移除不必要的$watch之性能优化"
date: 2015-11-11 20:20:58 +0800
comments: true
categories: [Angular, JavaScript, $watch]
---

双向绑定是Angular的核心概念之一，它给我们带来了思维方式的转变：不再是DOM驱动，而是以Model为核心，在View中写上声明式标签。然后，Angular就会在后台默默的同步View的变化到Model，并将Model的变化更新到View。

双向绑定带来了很大的好处，但是它需要在后台保持一只“眼睛”，随时观察所有绑定值的改变，这就是Angular 1.x中“性能杀手”的“脏检查机制”($digest)。可以推论：如果有太多“眼睛”，就会产生性能问题。在讨论优化Angular的性能之前，笔者希望先讲解下Angular的双向绑定和watchers函数。

###双向绑定和watchers函数

为了能够实现双向绑定，Angular使用了$watch API来监控$scope上的Model的改变。Angular应用在编译模板的时候，会收集模板上的声明式标签 —— 指令或绑定表达式，并链接（link）它们。这个过程中，指令或绑定表达式会注册自己的监控函数，这就是我们所说的watchers函数。

下面以我们常见的Angular表达式（`{% raw %}{{}}{% endraw %}`）为例。

HTML：
```html
<body ng-app="com.ngnice.app" ng-controller="DemoController as demo">
    <div>hello : {% raw %}{{demo.count}}{% endraw %}</div>
    <button type="button" ng-click="demo.increase ();">increase ++</button>
</body>
```

JavaScript：

```js
angular.module('com.ngnice.app')
.controller('DemoController', [function() {
  var vm = this;
  vm.count = 0;
  vm.increase = function() {
    vm.count++;
  };
  return vm;
}]);
```

这是一个自增长计数器的例子，在上面的代码我们用了Angular表达式（`{% raw %}{{}}{% endraw %}`）。表达式为了能在Model的值改变的时候你能及时更新View，它会在其所在的$scope（本例中为DemoController）中注册上面提到的watchers函数，监控count属性的变化，以便及时更新View。

上例中在每次点击button的时候，count计数器将会加1，然后count的变化会通过Angular的$digest过程同步到View之上。在这里它是一个单向的更新，从Model到View的更新。如果处理一个带有ngModel指令的input交互控件，则在View上的每次输入都会被及时更新到Model之上，这里则是反向的更新，从View到Model的更新。

Model数据能被更新到View是因为在背后默默工作的$digest循环（“脏检查机制”）被触发了。它会执行当前scope以及其所有子scope上注册的watchers函数，检测是否发生变化，如果变了就执行相应的处理函数，直到Model稳定了。如果这个过程中发生过变化，浏览器就会重新渲染受到影响的DOM来体现Model的变化。

在Angular表达式（`{% raw %}{{}}{% endraw %}`）背后的源码如下：

```js
function collectDirectives(node, directives, attrs, maxPriority, ignoreDirective) {
  var nodeType = node.nodeType,
    attrsMap = attrs.$attr,
    match,
    className;

  switch (nodeType) {
    case 1:
      /* Element */
      ...
      break;
    case 3:
      /* Text Node */
      addTextInterpolateDirective(directives, node.nodeValue);
      break;
    case 8:
      /* Comment */
      ...
      break;
  }

  directives.sort(byPriority);
  return directives;
}

function addTextInterpolateDirective(directives, text) {
  var interpolateFn = $interpolate(text, true);
  if (interpolateFn) {
    directives.push({
      priority: 0,
      compile: function textInterpolateCompileFn(templateNode) {
        // when transcluding a template that has bindings in the root
        // then we don't have a parent and should do this in the linkFn
        var parent = templateNode.parent(),
          hasCompileParent = parent.length;
        if (hasCompileParent) safeAddClass(templateNode.parent(), 'ng-binding');

        return function textInterpolateLinkFn(scope, node) {
          var parent = node.parent(),
            bindings = parent.data('$binding') || [];
          bindings.push(interpolateFn);
          parent.data('$binding', bindings);
          if (!hasCompileParent) safeAddClass(parent, 'ng-binding');
          scope.$watch(interpolateFn, function interpolateFnWatchAction(value) {
            node[0].nodeValue = value;
          });
        };
      }
    });
  }
}
```

Angular会在compile阶段收集View模板上的所有Directive。Angular表达式会被解析成一种特殊的指令：`addTextInterpolateDirective`。到了link阶段，就会利用scope.$watch的API注册我们在上面提到的watchers函数：它的求值函数为$interpolate对绑定表达式进行编译的结果，监听函数则是用新的表达式计算值去修改DOM Node的nodeValue。可见，在View中的Angular表达式，也会成为Angular在$digest循环中watchers的一员。

在上面代码中，还有一部分是为了给调试器用的。它会在Angular表达式所属的DOM节点加上名为‘ng-binding’的调试类。类似的调试类还有‘ng-scope’，‘ng-isolate-scope’等。在Angular 1.3中我们可以使用compileProvider服务来关闭这些调试信息。

```js
    app.config(['$compileProvider', function ($compileProvider) {
      // disable debug info
      $compileProvider.debugInfoEnabled(false);
    }]);
```

###其它指令中的watchers函数

不仅Angular的表达式会使用$scope.$watch API添加watchers，Angular内置的大部分指令也一样，下面再举几个常用的Angular指令。

ngBind：它和Angular表达式很类似，都是绑定特定表达式的值到DOM的内容，并保持与scope的同步。不同之处在于它需要一个HTML节点并以attribute属性的方式标记。简单来说，我们可以认为Angular表达式就是ngBind的特定语法糖。当然，还是有一点区别的，详情参见“使用技巧”一章的“防止Angular表达式闪烁”。

```js
    var ngBindDirective = ngDirective({
      compile: function(templateElement) {
        templateElement.addClass('ng-binding');
        return function (scope, element, attr) {
          element.data('$binding', attr.ngBind);
          scope.$watch(attr.ngBind, function ngBindWatchAction(value) {
            // We are purposefully using == here rather than === because we want to
            // catch when value is "null or undefined"
            // jshint -W041
            element.text(value == undefined ? '' : value);
          });
        };
      }
    });
```

这里也能清晰的看见$scope.$watch的注册代码：监控器函数为ngBind attribute的值，处理函数则是用表达式计算的结果去更新DOM的文本内容。

ngShow/ngHide: 它们是根据表达式的计算结果来控制显示/隐藏DOM节点的指令。

```js
    var ngShowDirective = ['$animate', function($animate) {
      return function(scope, element, attr) {
        scope.$watch(attr.ngShow, function ngShowWatchAction(value){
          $animate[toBoolean(value) ? 'removeClass' : 'addClass'](element, 'ng-hide');
        });
      };
    }];

    var ngHideDirective = ['$animate', function($animate) {
      return function(scope, element, attr) {
        scope.$watch(attr.ngHide, function ngHideWatchAction(value){
          $animate[toBoolean(value) ? 'addClass' : 'removeClass'](element, 'ng-hide');
        });
      };
    }];
```

这里同样用到了$scope.$watch，到这里你应该明白$watch的工作原理了吧。

再回到上面所提的性能问题。

如果有太多watcher函数，那么在每次$digest循环时，肯定会慢下来，这就是Angular“脏检查机制”的性能瓶颈。在社区中有个经验值，如果超过2000个watcher，就可能感觉到明显的卡顿，特别在IE8这种老旧浏览器上。有什么好的方案可以解决这个问题呢？最明显的方案是：减少$watch,尽量移除不必要的$watch。

###慎用$watch和及时销毁

要想提高Angular页面的性能，那么在开发的时候，就应该尽量减少显式使用$scope.$watch函数，Angular中的很多内置指令已经能够满足大部分的业务需求。特别是如果能复用ng内置的UI事件指令（ngChange、ngClick...），那么就不要添加额外的$watch。

对于不再使用的$watch，最好尽早将其释放，$scope.$watch函数的返回值就是用于释放这个watcher的函数，如下面的单次绑定实现（one-time）：

```js
angular.module('com.ngnice.app')
.controller('DemoController', ['$scope', function($scope) {
  var vm = this;
  vm.count = 0;
  var textWatch = $scope.$watch('demo.updated', function(newVal, oldVal) {
    if (newVal !== oldVal) {
      vm.count++;
      textWatch();
    }
  });
  return vm;
}]);
```

###one-time绑定

在开发中，经常会遇见很多有静态数据构成的页面，如静态的商品、订单等的显示，他们在绑定了数据之后，在当前页面中Model不再会被改变。试想我们需要显示一个培训会议Sessions的预约的展示页面，常规的Angular方案应该是用ng-repeat来产生这个列表：

HTML：
```html
<ul>
    <li ng-repeat="session in sessions">
        <div class="info">
           {% raw %} {{session.name}} - {{session.room}} - {{session.hour}} - {{session.speaker}}{% endraw %}
        </div>
        <div class="likes">
          {% raw %}  {{session.likes}} likes!{% endraw %}
            <button ng-click="likeSession(session)">Like it!</button>
        </div>
    </li>
</ul>
```
JavaScript：

```js
angular.module('com.ngnice.app')
.controller('MainController', ['$scope', function($scope) {
  $scope.sessions = [...];
  $scope.likeSession = function(session) {
    // Like the session
  }
}]);
```

用Angular来实现这个需求，很简单。但假设这是一个大型的预约，一天会有300个Sessions。那么这里会产生多少个$watch？这里每个Session有5个绑定，额外的ng-repeat一个。这将会产生1501个$watch。这有什么问题？每次用户“like”一个Session，Angular将会去检查name、room等5个属性是不是被改变了。

问题在于，除了例外的“like”外，所有数据都是静态数据，这是不是有点浪费资源？我们知道数据Model是没有被改变的，既然这样为什么让Angular要去检查是否改变呢？

因此，这里的$watch是没必要的，它的存在反而会影响$digest的性能，但这个$watch在第一次却是必要的，它在初始化时用静态信息填充了我们的DOM结构。对于这类情况，如果能换为单次（one-time）绑定应该是最佳的方案。

Angular中的单次（one-time）绑定是在1.3后引入的。在官方文档描述如下：

    单次表达式在第一次$digest完成后，将不再计算（监测属性的变化）。

1.3中为Angular表达式（`{% raw %}{{}}`{% endraw %}）引入了新语法，以“::”作为前缀的表达式为one-time绑定。对于上面的例子可以改为：
```html
<ul>
    <li ng-repeat="session in sessions">
        <div class="info">
           {% raw %} {{::session.name}} - {{::session.room}} - {{::session.hour}} - {{::session.speaker}}{% endraw %}
        </div>
        <div class="likes">
         {% raw %}   {{session.likes}} likes!{% endraw %}
            <button ng-click="likeSession(session)">Like it!</button>
        </div>
    </li>
</ul>
```
在1.3之前的版本没有提供这个语法，我们应该如何实现one-time绑定呢？在开源社区中有个牛人在我们之前也问了自己这个问题，并创建了一系列指令来实现它：Bindonce [https://github.com/Pasvaz/bindonce](https://github.com/Pasvaz/bindonce)。用Bindonce实现如下：

```html
<ul>
    <li bindonce ng-repeat="session in sessions">
        <div class="info">
            <span bo-text="session.name"></span> -
            <span bo-text="session.room"></span> -
            <span bo-text="session.hour"></span> -
            <span bo-text="session.speaker"></span>
        </div>
        <div class="likes">
          {% raw %}  {{session.likes}} likes!{% endraw %}
            <button ng-click="likeSession(session)">Like it!</button>
        </div>
    </li>
</ul>
```

为了让示例能够工作，需要引入bindonce库，并依赖pasvaz.bindonce module。

    angular.module('com.ngnice.app', ['pasvaz.bindonce']);

并把Angular表达式改成bo-text指令。该指令将会绑定到Model，直到更新DOM，然后自动释放watcher。这样，显示功能仍然工作，但不再使用不必要的$watch。在这里每个Session只有一个$watch绑定，用301个绑定替代了1501个绑定。

恰当的使用bingonce或者1.3的one-time绑定能为应用one程序减少大量不必要$watch绑定，从而提高应用性能。 

###滚屏加载

另外一种可行的性能解决方案就是滚屏加载，又称"Endless Scrolling," "unpagination"，这是用于大量数据集显示的时候，又不想表格分页，所以一般放在页面最底部，当滚动屏幕到达页面底部的时候，就会尝试加载一个序列的数据集，追加在页面底部。在Angular社区有开源组件ngInfiniteScroll [http://binarymuse.github.io/ngInfiniteScroll/index.html](http://binarymuse.github.io/ngInfiniteScroll/index.html)实现滚屏加载。下面是官方Demo：

HTML：

```html
    <div ng-app='myApp' ng-controller='DemoController'>
      <div infinite-scroll='reddit.nextPage()' infinite-scroll-disabled='reddit.busy' infinite-scroll-distance='1'>
        <div ng-repeat='item in reddit.items'>
          <span class='score'>{% raw %}{{item.score}}{% endraw %}</span>
          <span class='title'>
            <a ng-href='{% raw %}{{item.url}}{% endraw %}' target='_blank'>{% raw %}{{item.title}}{% endraw %}</a>
          </span>
          <small>by {% raw %}{{item.author}} -{% endraw %}
            <a ng-href='http://reddit.com{% raw %}{{item.permalink}}{% endraw %}' target='_blank'>{% raw %}{{item.num_comments}} {% endraw %}comments</a>
          </small>
          <div style='clear: both;'></div>
        </div>
        <div ng-show='reddit.busy'>Loading data...</div>
      </div>
    </div>
```

JavaScript：

```js
    var myApp = angular.module('myApp', ['infinite-scroll']);

    myApp.controller('DemoController', ['$scope', 'Reddit', function($scope, Reddit) {
      $scope.reddit = new Reddit();
    }]);

    // Reddit constructor function to encapsulate HTTP and pagination logic
    myApp.factory('Reddit', ['$http', function($http) {
      var Reddit = function() {
        this.items = [];
        this.busy = false;
        this.after = '';
      };

      Reddit.prototype.nextPage = function() {
        if (this.busy) return;
        this.busy = true;

        var url = 'http://api.reddit.com/hot?after=' + this.after + '&jsonp=JSON_CALLBACK';
        $http.jsonp(url).success(function(data) {
          var items = data.data.children;
          for (var i = 0; i < items.length; i++) {
            this.items.push(items[i].data);
          }
          this.after = 't3_' + this.items[this.items.length - 1].id;
          this.busy = false;
        }.bind(this));
      };

      return Reddit;
    }]);
```

可以在这里[http://binarymuse.github.io/ngInfiniteScroll/demo_async.html](http://binarymuse.github.io/ngInfiniteScroll/demo_async.html)访问这个例子。其使用很简单，有兴趣的读者可以查看其官方文档。

###其它

当然对于性能解决方案还有很多，如客户端分页、服务端分页、将其它更高效的jQuery插件或者React插件合理的封装为ng组件等。当封装第三方非Angular组件时需要注意scope和model的同步，以及合理的触发$apply更新View。另外在开源社区中也有ngReact可以简化将React组件应用到Angular应用中，在这里可以了解到关于它的更多信息：[https://github.com/davidchang/ngReact](https://github.com/davidchang/ngReact)。

此刻，我猜你一定正是心中默默嘀咕着：Angular“脏检查机制”一定很慢，一个“肮脏”的家伙。但这是错误的。它其实很快，Angular团队为此专门做了很多优化。相反，在大多数场景下，Angular这种特殊的watcher机制，反而比很多基于JavaScript模板引擎（underscore、Handlebars等）更快。因为Angular并不需要通过大范围的DOM操作来更新View，它的每次更新区域更小，DOM操作更少。而DOM操作的代价远远高过JavaScript运算，在有些浏览器中，修改DOM的速度甚至会比纯粹的JavaScript运算慢很多倍！

而且，在现实场景中，我们的大多数页面都不会超出2000个watcher，因为过多的信息对使用者是非常不友好的，好的设计师都懂得限制单页信息的展示量。但是如果超过了2000个watcher，那么你就得仔细思考如何去优化它了，应该优先选择从用户体验方面改进，实在不行就用上面提到的技巧来优化你的应用程序。

最后，随着Angular 2.0框架对“脏检查机制”的改进，运行性能将会得到显著地提高，特别是针对Mobile开发的ionic这类框架，将直接受益。
