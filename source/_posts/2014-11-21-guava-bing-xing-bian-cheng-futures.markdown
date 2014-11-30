---
layout: post
title: "Guava - 并行编程Futures"
date: 2014-11-21 20:41:30 +0800
comments: true
categories: [Guava, Java]
---
Guava为Java并行编程Future提供了很多有用扩展，其主要接口为ListenableFuture，并借助于Futures静态扩展。

继承至Future的ListenableFuture，允许我们添加回调函数在线程运算完成时返回值或者方法执行完成立即返回。

对ListenableFuture添加回调函数：

	Futures.addCallback(ListenableFuture<V>, FutureCallback<V>, Executor)

其中 FutureCallback<V>是一个包含onSuccess(V),onFailure(Throwable)的接口。

使用如：

	Futures.addCallback(ListenableFuture, new FutureCallback<Object>() {

        public void onSuccess(Object result) {
            System.out.printf("onSuccess with: %s%n", result);
        }

        public void onFailure(Throwable thrown) {
            System.out.printf("onFailure %s%n", thrown.getMessage());
        }
    });

同时Guava中Futures对于Future扩展还有：

transform：对于ListenableFuture的返回值进行转换。

allAsList：对多个ListenableFuture的合并，返回一个当所有Future成功时返回多个Future返回值组成的List对象。注：当其中一个Future失败或者取消的时候，将会进入失败或者取消。

successfulAsList：和allAsList相似，唯一差别是对于失败或取消的Future返回值用null代替。不会进入失败或者取消流程。

immediateFuture/immediateCancelledFuture： 立即返回一个待返回值的ListenableFuture。

makeChecked: 将ListenableFuture 转换成CheckedFuture。CheckedFuture 是一个ListenableFuture ，其中包含了多个版本的get 方法，方法声明抛出检查异常.这样使得创建一个在执行逻辑中可以抛出异常的Future更加容易

JdkFutureAdapters.listenInPoolThread(future): guava同时提供了将JDK Future转换为ListenableFuture的接口函数。

下边是一个对于Future的测试demo：

	@Test
	public void should_test_furture() throws Exception {
	    ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));

	    ListenableFuture future1 = service.submit(new Callable<Integer>() {
	        public Integer call() throws InterruptedException {
	            Thread.sleep(1000);
	            System.out.println("call future 1.");
	            return 1;
	        }
	    });

	    ListenableFuture future2 = service.submit(new Callable<Integer>() {
	        public Integer call() throws InterruptedException {
	            Thread.sleep(1000);
	            System.out.println("call future 2.");
		//       throw new RuntimeException("----call future 2.");
	            return 2;
	        }
	    });

	    final ListenableFuture allFutures = Futures.allAsList(future1, future2);

	    final ListenableFuture transform = Futures.transform(allFutures, new AsyncFunction<List<Integer>, Boolean>() {
	        @Override
	        public ListenableFuture apply(List<Integer> results) throws Exception {
	            return Futures.immediateFuture(String.format("success future:%d", results.size()));
	        }
	    });

	    Futures.addCallback(transform, new FutureCallback<Object>() {

	        public void onSuccess(Object result) {
	            System.out.println(result.getClass());
	            System.out.printf("success with: %s%n", result);
	        }

	        public void onFailure(Throwable thrown) {
	            System.out.printf("onFailure%s%n", thrown.getMessage());
	        }
	    });

	    System.out.println(transform.get());
	}

   官方资料主页：[https://awk.so/@code.google.com!/p/guava-libraries/wiki/ListenableFutureExplained](https://awk.so/@code.google.com!/p/guava-libraries/wiki/ListenableFutureExplained)

更多Guava博文：

1. [Guava - 并行编程Futures](http://greengerong.github.io/blog/2014/11/21/guava-bing-xing-bian-cheng-futures/)
2. [Guava - EventBus(事件总线)](http://greengerong.github.io/blog/2014/11/27/guava-eventbus/)

