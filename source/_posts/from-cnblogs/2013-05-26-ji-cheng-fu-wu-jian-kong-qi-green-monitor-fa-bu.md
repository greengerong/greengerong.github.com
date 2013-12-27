---
layout: post
title: "集成服务监控器-green.monitor发布"
description: "集成服务监控器-green.monitor发布"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; &nbsp; &nbsp; 在大型企业应用开发中，一个项目经常需要依赖于多个项目集成，经常某个集成服务的升级或者不工作，会导致你所工作的服务也挂掉，甚至影响你的开发流程。你是否还在接到测试团队或者运维团队的某个Bug，而自己花费了大量时间终于查出来是某个集成服务升级或异常，在这里浪费了大量时间，在笔者为所在项目建立了一个第三方集成服务监控的Monitor，去实时监控项目所依赖的所有集成服务，数据库。现在开源在github [https://github.com/greengerong/green-monitor](https://github.com/greengerong/green-monitor)，在其sample目录下有个使用demo。

## _maven&nbsp;_dependency

<div class="cnblogs_code">
<pre><span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.github.greengerong<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>green.monitor<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span></pre>
</div>

&nbsp;

## demo效果如下：

![](http://images.cnitblog.com/blog/63184/201305/26183719-93e330e6d3b04c219f0ea423b973a356.png)

# 建立自己的monitor：

1：首先在你spring mvc web project 的 pom文件中引 入green-monitor的dependency。(spring 3.0以上)
2：在spring mvc的 ioc context config中启用annotation dirver，如下xml：

<div class="cnblogs_code">
<pre><span style="color: #0000ff;">&lt;?</span><span style="color: #ff00ff;">xml version="1.0" encoding="UTF-8"</span><span style="color: #0000ff;">?&gt;</span>
  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">beans </span><span style="color: #ff0000;">xmlns</span><span style="color: #0000ff;">="http://www.springframework.org/schema/beans"</span><span style="color: #ff0000;">
         xmlns:xsi</span><span style="color: #0000ff;">="http://www.w3.org/2001/XMLSchema-instance"</span><span style="color: #ff0000;">
         xmlns:p</span><span style="color: #0000ff;">="http://www.springframework.org/schema/p"</span><span style="color: #ff0000;">
         xmlns:mvc</span><span style="color: #0000ff;">="http://www.springframework.org/schema/mvc"</span><span style="color: #ff0000;">
         xmlns:context</span><span style="color: #0000ff;">="http://www.springframework.org/schema/context"</span><span style="color: #ff0000;">
         xmlns:util</span><span style="color: #0000ff;">="http://www.springframework.org/schema/util"</span><span style="color: #ff0000;">
         xsi:schemaLocation</span><span style="color: #0000ff;">="http://www.springframework.org/schema/beans
               http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
               http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd
               http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd
               http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util-3.0.xsd"</span><span style="color: #0000ff;">&gt;</span>

      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">mvc:annotation-driven</span><span style="color: #0000ff;">/&gt;</span>

      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context:component-scan </span><span style="color: #ff0000;">base-package</span><span style="color: #0000ff;">="green.monitor"</span><span style="color: #0000ff;">/&gt;</span>

      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">class</span><span style="color: #0000ff;">="org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter"</span><span style="color: #0000ff;">/&gt;</span>

      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="viewResolver"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.springframework.web.servlet.view.InternalResourceViewResolver"</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="prefix"</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>/WEB-INF/pages/<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="suffix"</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>.jsp<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
      <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>
  <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">beans</span><span style="color: #0000ff;">&gt;</span></pre>
</div>

&nbsp;

3:在项目resources(mian/resources)下建立monitor-config.xml。如果需要 在不同环境配置不同信息，可以在运行机器上加入key为appenv的环境变量，程序会根据不同agent加载monitor-config.[appenv].xml配置文件.或者利用mavn，gradle这类构建工具按环境输出配置信息。

配置文件形如：

<div class="cnblogs_code">
<pre><span style="color: #0000ff;">&lt;?</span><span style="color: #ff00ff;">xml version="1.0" encoding="UTF-8"</span><span style="color: #0000ff;">?&gt;</span>
      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">monitoring </span><span style="color: #ff0000;">version</span><span style="color: #0000ff;">="1.0"</span><span style="color: #ff0000;"> name</span><span style="color: #0000ff;">="monitor-sample"</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">monitors</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">monitor </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="mock-monitor"</span><span style="color: #0000ff;">&gt;</span>green.monitor.demo.MockMonitorRunner<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">monitor</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">monitors</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">items</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">item </span><span style="color: #ff0000;">monitor</span><span style="color: #0000ff;">="http-connection"</span><span style="color: #ff0000;"> name</span><span style="color: #0000ff;">="hello service"</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">params</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="url"</span><span style="color: #0000ff;">&gt;</span>http://localhost:8080/demo/hello<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="method"</span><span style="color: #0000ff;">&gt;</span>GET<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="response-code"</span><span style="color: #0000ff;">&gt;</span>200<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="param"</span><span style="color: #0000ff;">&gt;</span>name=success<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">params</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>This is a monitor for hello service.should be success.<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">item</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">item </span><span style="color: #ff0000;">monitor</span><span style="color: #0000ff;">="http-connection"</span><span style="color: #ff0000;"> name</span><span style="color: #0000ff;">="error service 2"</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">params</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="url"</span><span style="color: #0000ff;">&gt;</span>http://localhost:8080/demo/failed<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="method"</span><span style="color: #0000ff;">&gt;</span>GET<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="response-code"</span><span style="color: #0000ff;">&gt;</span>200<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                      <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="param"</span><span style="color: #0000ff;">&gt;</span>name=must be failed<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">params</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>This is a monitor for error service.should be failed.<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">item</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">item </span><span style="color: #ff0000;">monitor</span><span style="color: #0000ff;">="mock-monitor"</span><span style="color: #ff0000;"> name</span><span style="color: #0000ff;">="Random failed Service"</span><span style="color: #0000ff;">&gt;</span>
                  <span style="color: #0000ff;">&lt;</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>This monitor will be random failed!<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">description</span><span style="color: #0000ff;">&gt;</span>
              <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">item</span><span style="color: #0000ff;">&gt;</span>
          <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">items</span><span style="color: #0000ff;">&gt;</span>
      <span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">monitoring</span><span style="color: #0000ff;">&gt;</span></pre>
</div>

&nbsp;

这样你就可以运行monitor了，url为host + &ldquo;/monitor&rdquo;

# 扩展

1：扩展runner 同时monitor为你提供了自我特定需求扩展的机会，在xml config中你应该主意到了有个monitor的配置节，这里就可以配置你自定义runner（其实现MonitorRunner接口),配置节name则作为后边item的引用name。

系统默认加入了web-service,dababase,http-connection3个常用runner。具体使用请看demo。
2：系统提供了service为基于spring restfull api,所以你可以在其他地方展示该monitor状况。(在下一个版本将提供jsonp的跨域处理)。

&nbsp; &nbsp;monitor project repo:&nbsp;[https://github.com/greengerong/green-monitor](https://github.com/greengerong/green-monitor)

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/05/26/3100241.html "原文首发")