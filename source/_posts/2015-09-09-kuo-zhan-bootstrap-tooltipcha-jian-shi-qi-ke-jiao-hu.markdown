---
layout: post
title: "扩展bootstrap tooltip插件使其可交互"
date: 2015-09-09 13:20:20 +0800
comments: true
categories: [javascript, bootstrap, jquery]
---
  
最近在公司某项目开发中遇见一特殊需求，请笔者帮助，因此有了本文的插件。在前端开发中tooltip是一个极其常用的插件，它能更好向使用者展示更多的文档等帮助信息。它们通常都是一些静态文本信息。但同事他们的需求是需要动态交互，在文本信息中存在帮助网页的链接。如果使用常规tooltip，则在用户移出tooltip依赖DOM节点后，tooltip panel则将被隐藏。所以用户没有办法点击到这些交互链接。

所以我们期望：给用户一定的时间使得用户能够将鼠标从依赖节点移动到tooltip panel；并且如果用户鼠标停留在tooltip上则不能隐藏，使得用户能够与位于tooltip上的链接或者是其他form表单控件交互。

也许你觉得这并不难，在网上Google就有很多代码可直接使用。是的，如下面这段来自plnkr.co的代码（[http://plnkr.co/edit/x2VMhh?p=preview](http://plnkr.co/edit/x2VMhh?p=preview)）：
    
	$(".pop").popover({ trigger: "manual" , html: true, animation:false})
	    .on("mouseenter", function () {
	        var _this = this;
	        $(this).popover("show");
	        $(".popover").on("mouseleave", function () {
	            $(_this).popover('hide');
	        });
	    }).on("mouseleave", function () {
	        var _this = this;
	        setTimeout(function () {
	            if (!$(".popover:hover").length) {
	                $(_this).popover("hide");
	            }
	        }, 300);
	});


它是使用bootstrap的popover来实现的，从bootstrap的源码能看到popover是继承至tooltip的组件之一。这里是通过将popover的触发方式设为手动触发，由我们自己来控制显示和隐藏它的时机。并且在依赖节点离开的时候，给定300ms的延迟等待用户进入tooltip panel，如果300ms还没有进入tooltip则隐藏它。否则就阻止隐藏tooltip的逻辑。

这代码虽然功能可用，但具有代码洁癖的博主并不太满意这样的代码。它难以阅读维护，同时重用性也将极差。所以笔者决定要以bootstrap插件方式来一bs way写这款插件。

当笔者查阅bootstrap tooltip源码时，发现它是一个扩展性很不错的插件。tooltip的显示和隐藏依赖于它内部的hoverState状态来控制，in代表在依赖节点元素之上，out则代表移出了DOM元素。并且它也支持延迟动画机制。所以我们可以如下方式控制hoverState的状态：

	var DelayTooltip = function (element, options) {
    	this.init('delayTooltip', element, options);
		this.initDelayTooltip();
  	};

  	DelayTooltip.DEFAULTS = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, {
    	trigger: 'hover',
		delay: {hide: 600}
  	});

	DelayTooltip.prototype.delayTooltipEnter = function(){
			this.hoverState = 'in';
		};
		
		DelayTooltip.prototype.delayTooltipLeave = function(){
			this.hoverState = 'out';
			this.leave(this);
		};
			
	  DelayTooltip.prototype.initDelayTooltip = function(){
		  this.tip()
			  .on('mouseenter.'  +  this.type, $.proxy(this.delayTooltipEnter, this))
	          .on('mouseleave.' + this.type, $.proxy(this.delayTooltipLeave, this));
	  };

这里在构造tooltip对象同时也注册tooltip panel的mouseenter、mouseleave.事件，并设置对应的hoverState状态。当移出tooltip panel时，这里需要手动的调用来自tooltip继类的leave方法。对于隐藏延时则设置在默认option中，使其能够可配置。

上面的代码就是我们所需要扩展tooltip的所有的代码。当然要想作为一个通用的bootstrap插件，还需要它固定的插件配置代码。插件全部代码如下：

	(function ($) {
	  'use strict';

	  var DelayTooltip = function (element, options) {
	    this.init('delayTooltip', element, options);
		this.initDelayTooltip();
	  };

	  if (!$.fn.tooltip) throw new Error('Popover requires tooltip.js');

	  DelayTooltip.VERSION  = '0.1';

	  DelayTooltip.DEFAULTS = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, {
	    trigger: 'hover',
		delay: {hide: 600}
	  });

	  DelayTooltip.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype);

	  DelayTooltip.prototype.constructor = DelayTooltip;

	  DelayTooltip.prototype.getDefaults = function () {
	    return DelayTooltip.DEFAULTS;
	  };
		
		DelayTooltip.prototype.delayTooltipEnter = function(){
			this.hoverState = 'in';
		};
		
		DelayTooltip.prototype.delayTooltipLeave = function(){
			this.hoverState = 'out';
			this.leave(this);
		};
			
	  DelayTooltip.prototype.initDelayTooltip = function(){
		  this.tip()
			  .on('mouseenter.'  +  this.type, $.proxy(this.delayTooltipEnter, this))
	          .on('mouseleave.' + this.type, $.proxy(this.delayTooltipLeave, this));
	  };
		
	  function Plugin(option) {
	    return this.each(function () {
	      var $this   = $(this);
	      var data    = $this.data('bs.delayTooltip');
	      var options = typeof option == 'object' && option;

	      if (!data && /destroy|hide/.test(option)) return;
	      if (!data) $this.data('bs.delayTooltip', (data = new DelayTooltip(this, options)));
	      if (typeof option == 'string') data[option]();
	    });
	  }

	  var old = $.fn.delayTooltip;

	  $.fn.delayTooltip             = Plugin;
	  $.fn.delayTooltip.Constructor = DelayTooltip;

	  $.fn.delayTooltip.noConflict = function () {
	    $.fn.delayTooltip = old;
	    return this;
	  };

	})(jQuery);

这里基本都是bootstrap插件机制的固定模板，仅仅需要套用上就行。有了这个插件扩展，那么我们就可以如下使用这款插件：你也可以在jsbin中查看效果[http://jsbin.com/wicoki/edit?html,js,output](http://jsbin.com/wicoki/edit?html,js,output):

HTML:


	<div id="tooltip">bs tooltip:你能点击链接？</div>
	<hr>
	<div  id="delayTooltip">delay tooltip：尝试点击链接</div>
	<hr>
	<div id="delayTooltipInHtml" data-html="true" data-placement="bottom" data-toggle="delayTooltip">delay tooltip:利用html标签实现</div>

JavaScript 代码：

	(function(global, $){
	  
		var page = function(){
		  
		};
		
		page.prototype.bootstrap = function(){
			var html = 'Weclome to my blog <a target="_blank" href="greengerong.github.io">破狼博客</a>!<input type="text" placeholder="input some thing"/>';
			$('#tooltip').tooltip( {
				html: true,
				placement: 'top',
				title: html
			});
			
			$('#delayTooltip').delayTooltip( {
				html: true,
				placement: 'bottom',
				title: html
			});
			
	  $('#delayTooltipInHtml').attr('title', html).delayTooltip();
			
	  return this;
	};
		
		 global.Page = page;
		
	})(this, jQuery);

	$(function(){
		'use strict';
	  var page = new window.Page().bootstrap();
		//
	});
		
			
这款插件既支持jQuery在HTML中声明属性的方式，同时也可以在javascript中使用。效果如下：

![bootstrap dealy-tooltip](/images/blog_img/delay-tooltip-example.png)


