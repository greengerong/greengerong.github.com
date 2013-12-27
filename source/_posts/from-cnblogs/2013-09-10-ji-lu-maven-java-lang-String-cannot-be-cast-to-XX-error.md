---
layout: post
title: "记录maven java.lang.String cannot be cast to XX error"
description: "记录maven java.lang.String cannot be cast to XX error"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; &nbsp; &nbsp;在项目开发中自定义了一个maven plugin，在本地能够很好的工作，但是在ci server上却无法正常工作报错为：

<div class="cnblogs_Highlighter">
<pre class="brush:java;gutter:false;">-----------------------------------------------------

         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:225)
         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:153)
         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:145)
         at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:84)
         at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:59)
         at org.apache.maven.lifecycle.internal.LifecycleStarter.singleThreadedBuild(LifecycleStarter.java:183)
         at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:161)
         at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:319)
         at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:156)
         at org.jvnet.hudson.maven3.launcher.Maven3Launcher.main(Maven3Launcher.java:79)
         at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
         at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
         at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
         at java.lang.reflect.Method.invoke(Method.java:601)
         at org.codehaus.plexus.classworlds.launcher.Launcher.launchStandard(Launcher.java:329)
         at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:239)
         at org.jvnet.hudson.maven3.agent.Maven3Main.launch(Maven3Main.java:146)
         at hudson.maven.Maven3Builder.call(Maven3Builder.java:127)
         at hudson.maven.Maven3Builder.call(Maven3Builder.java:74)
         at hudson.remoting.UserRequest.perform(UserRequest.java:118)
         at hudson.remoting.UserRequest.perform(UserRequest.java:48)
         at hudson.remoting.Request$2.run(Request.java:326)
         at hudson.remoting.InterceptingExecutorService$1.call(InterceptingExecutorService.java:72)
         at java.util.concurrent.FutureTask$Sync.innerRun(FutureTask.java:334)
         at java.util.concurrent.FutureTask.run(FutureTask.java:166)
         at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1110)
         at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:603)
         at java.lang.Thread.run(Thread.java:722)
Caused by: org.apache.maven.plugin.PluginExecutionException: A type incompatibility occured while executing [group id]:[artifact id]:[version]:start: java.lang.String cannot be cast to java.io.File
-----------------------------------------------------
</pre>
</div>

&nbsp; &nbsp; &nbsp; 在花费了我大半的时间，将本地环境的maven，jdk等设为和ci一致后最后定位到maven的版本问题，其终究原因是因为maven在3.0.3才支持配置参数为泛型集合(List&lt;T&gt;,Set&lt;T&gt;...)，在3.0.2及一下本班不支持此写法。

&nbsp; &nbsp; &nbsp;修改次error的方法有两种：

1.  将ci Server的maven更新到3.0.3以上。(但是在我们的ci server更新有些困难，还有本人认为如果写一个plugin只能工作的固定version，这和一个废物差不多，所以选择了第二种方法)。
2.  将泛型集合List&lt;T&gt;改为Array T[]。（项目中某大神写的List&lt;File&gt;我轻易的改为File[].在执行前改为Arrays.asList(XXX)）;

&nbsp; &nbsp; &nbsp;一切搞定。在此记录希望对于遇见同类问题的人有所帮助。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/09/10/3313515.html "原文首发")