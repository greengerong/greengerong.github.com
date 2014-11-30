---
layout: post
title: "Guava - EventBus(事件总线)"
date: 2014-11-27 21:49:40 +0800
comments: true
categories: [Guava, Java]
---
Guava在[guava-libraries](http://code.google.com/p/guava-libraries/)中为我们提供了事件总线EventBus库，它是事件发布订阅模式的实现，让我们能在领域驱动设计(DDD)中以事件的弱引用本质对我们的模块和领域边界很好的解耦设计。

不再多的废话，直奔Guava EventBus主题。首先Guava为我们提供了同步事件EventBus和异步实现AsyncEventBus两个事件总线，他们都不是单例的，官方理由是并不想我们我们的使用方式。当然如果我们想其为单例，我们可以很容易封装它，一个单例模式保证只创建一个实例就对了。

下面将以EventBus为例，AsyncEventBus使用方式与其一致的。

####订阅
首先EventBus为我们提供了register方法来订阅事件，Guava在这里的实现很友好，我们不需要实现任何的额外接口或者base类，只需要在订阅方法上标注上**@Subscribe**和保证**只有一个输入参数**的方法就可以搞定。这样对于简单的某些事件，我们甚至可以直接

	new Object() {

	    @Subscribe
	    public void lister(Integer integer) {
	        System.out.printf("%d from int%n", integer);
	    }
	}

Guava发布的事件默认不会处理线程安全的，但我们可以标注@AllowConcurrentEvents来保证其线程安全

####发布
对于事件源，则可以通过post方法发布事件。 正在这里对于Guava对于事件的发布，是依据上例中订阅方法的方法参数类型决定的，换而言之就是post传入的类型和其基类类型可以收到此事件。例如下例：

	final EventBus eventBus = new EventBus();
    eventBus.register(new Object() {

        @Subscribe
        public void lister(Integer integer) {
            System.out.printf("%s from int%n", integer);
        }

        @Subscribe
        public void lister(Number integer) {
            System.out.printf("%s from Number%n", integer);
        }

        @Subscribe
        public void lister(Long integer) {
            System.out.printf("%s from long%n", integer);
        }
    });

	eventBus.post(1);
	eventBus.post(1L);

在这里有	Integer，Long，与它们基类Number。我们发送一个整数数据的时候，或者Integer和Number的方法接收，而Long类型则Long类型和Number类型接受。

所以博主建议对于每类时间封装一个特定的事件类型是必要的。

####DeadEvent
DeadEvent暂时不清楚怎么翻译更合意，它描述的是死亡事件，即没有没任何订阅者关心，没有被处理，以DeadEvent类型参数的方法表示.例如在上例中我们post一个Object类型，如下：

	final EventBus eventBus = new EventBus();
	eventBus.register(new Object() {

	    @Subscribe
	    public void lister(DeadEvent event) {
	        System.out.printf("%s=%s from dead events%n", event.getSource().getClass(), event.getEvent());
	    }
	});

	eventBus.post(new Object());

更多Guava博文：

1. [Guava 并行编程Futures](http://greengerong.github.io/blog/2014/11/21/guava-bing-xing-bian-cheng-futures/)
2. [Guava之EventBus(事件总线)](http://greengerong.github.io/blog/2014/11/27/guava-eventbus/)
