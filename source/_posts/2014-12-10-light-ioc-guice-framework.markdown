---
layout: post
title: "java轻量级IOC框架Guice"
date: 2014-12-10 21:50:37 +0800
comments: true
categories: [java,ioc,Guice]
---
Guice是由Google大牛Bob lee开发的一款绝对轻量级的java IoC容器。其优势在于：

1. 速度快，号称比spring快100倍。
2. 无外部配置(如需要使用外部可以可以选用Guice的扩展包)，完全基于annotation特性，支持重构，代码静态检查。
3. 简单，快速，基本没有学习成本。

Guice和spring各有所长，Guice更适合与嵌入式或者高性能但项目简单方案，如OSGI容器，spring更适合大型项目组织。

##注入方式
在我们谈到IOC框架，首先我们的话题将是构造，属性以及函数注入方式，Guice的实现只需要在构造函数，字段，或者注入函数上标注@Inject，如：

####构造注入

	public class OrderServiceImpl implements OrderService {
	    private ItemService itemService;
	    private PriceService priceService;

	    @Inject
	    public OrderServiceImpl(ItemService itemService, PriceService priceService) {
	        this.itemService = itemService;
	        this.priceService = priceService;
	    }

	    ...
	}

####属性注入

	public class OrderServiceImpl implements OrderService {
	    private ItemService itemService;
	    private PriceService priceService;

	    @Inject
	    public void init(ItemService itemService, PriceService priceService) {
	        this.itemService = itemService;
	        this.priceService = priceService;
	    }

	    ...
	}

####函数(setter)注入

	public class OrderServiceImpl implements OrderService {
	    private ItemService itemService;
	    private PriceService priceService;

	    @Inject
	    public void setItemService(ItemService itemService) {
	        this.itemService = itemService;
	    }

	    @Inject
	    public void setPriceService(PriceService priceService) {
	        this.priceService = priceService;
	    } 

	    ...
	}


##Module依赖注册

Guice提供依赖配置类，需要继承至AbstractModule，实现configure方法。在configure方法中我们可以用Binder配置依赖。

Binder利用链式形成一套独具语义的DSL，如：

*	基本配置：binder.bind(serviceClass).to(implClass).in(Scopes.[SINGLETON | NO_SCOPE]);
*   无base类、接口配置：binder.bind(implClass).in(Scopes.[SINGLETON | NO_SCOPE]);
*   service实例配置：binder.bind(serviceClass).toInstance(servieInstance).in(Scopes.[SINGLETON | NO_SCOPE]);
*   多个实例按名注入：binder.bind(serviceClass).annotatedWith(Names.named("name")).to(implClass).in(Scopes.[SINGLETON | NO_SCOPE]);
*   运行时注入：利用@Provides标注注入方法，相当于spring的@Bean。
*   @ImplementedBy：或者在实现接口之上标注@ImplementedBy指定其实现类。这种方式有点反OO设计，抽象不该知道其实现类。

对于上面的配置在注入的方式仅仅需要@Inject标注，但对于按名注入需要在参数前边加入@Named标注，如：

 	public void configure() {
        final Binder binder = binder();
        
        //TODO: bind named instance;
        binder.bind(NamedService.class).annotatedWith(Names.named("impl1")).to(NamedServiceImpl1.class);
        binder.bind(NamedService.class).annotatedWith(Names.named("impl2")).to(NamedServiceImpl2.class);
    }

    @Inject
	public List<NamedService> getAllItemServices(@Named("impl1") NamedService nameService1,
	                                                 @Named("impl2") NamedService nameService2) {
	}

Guice也可以利用@Provides标注注入方法来运行时注入：如

    @Provides
    public List<NamedService> getAllItemServices(@Named("impl1") NamedService nameService1,
                                                 @Named("impl2") NamedService nameService2) {
        final ArrayList<NamedService> list = new ArrayList<NamedService>();
        list.add(nameService1);
        list.add(nameService2);
        return list;
    }

##Guice实例
下面是一个Guice module的实例代码：包含大部分常用依赖配置方式。更多代码参见[github ](https://github.com/greengerong/guice-demo).

	package com.github.greengerong.app;

	/**
	 * ***************************************
	 * *
	 * Auth: green gerong                     *
	 * Date: 2014                             *
	 * blog: http://greengerong.github.io/    *
	 * github: https://github.com/greengerong *
	 * *
	 * ****************************************
	 */
	public class AppModule extends AbstractModule {
	    private static final Logger LOGGER = LoggerFactory.getLogger(AppModule.class);
	    private final BundleContext bundleContext;

	    public AppModule(BundleContext bundleContext) {
	        this.bundleContext = bundleContext;
	        LOGGER.info(String.format("enter app module with: %s", bundleContext));
	    }

	    @Override
	    public void configure() {
	        final Binder binder = binder();
	        //TODO: bind interface
	        binder.bind(ItemService.class).to(ItemServiceImpl.class).in(SINGLETON);
	        binder.bind(OrderService.class).to(OrderServiceImpl.class).in(SINGLETON);
	        //TODO: bind self class(without interface or base class)
	        binder.bind(PriceService.class).in(Scopes.SINGLETON);


	        //TODO: bind instance not class.
	        binder.bind(RuntimeService.class).toInstance(new RuntimeService());

	        //TODO: bind named instance;
	        binder.bind(NamedService.class).annotatedWith(Names.named("impl1")).to(NamedServiceImpl1.class);
	        binder.bind(NamedService.class).annotatedWith(Names.named("impl2")).to(NamedServiceImpl2.class);
	    }

	    @Provides
	    public List<NamedService> getAllItemServices(@Named("impl1") NamedService nameService1,
	                                                 @Named("impl2") NamedService nameService2) {
	        final ArrayList<NamedService> list = new ArrayList<NamedService>();
	        list.add(nameService1);
	        list.add(nameService2);
	        return list;
	    }
	}

##Guice的使用

对于Guice的使用则比较简单，利用利用Guice module初始化Guice创建其injector，如：

	Injector injector = Guice.createInjector(new AppModule(bundleContext));

这里可以传入多个module，我们可以利用module分离领域依赖。

Guice api方法：
 	
 	public static Injector createInjector(Module... modules) 

    public static Injector createInjector(Iterable<? extends Module> modules) 

    public static Injector createInjector(Stage stage, Module... modules)

    public static Injector createInjector(Stage stage, Iterable<? extends Module> modules) 

Guice同时也支持不同Region配置，上面的State重载，state支持 TOOL,DEVELOPMENT,PRODUCTION选项;默认为DEVELOPMENT环境。

##后续
本文Guice更全的demo代码请参见[github ](https://github.com/greengerong/guice-demo).

Guice还有很多的扩展如AOP，同一个服务多个实例注入set，map，OSGI，UOW等扩展，请参见[Guice wiki](https://github.com/google/guice/wiki).

