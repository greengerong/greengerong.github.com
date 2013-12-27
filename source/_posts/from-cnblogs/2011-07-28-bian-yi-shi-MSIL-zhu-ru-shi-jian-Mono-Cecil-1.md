---
layout: post
title: "编译时MSIL注入--实践Mono Cecil(1)"
description: "编译时MSIL注入--实践Mono Cecil(1)"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp; 紧接上两篇[浅谈.NET编译时注入（C#--&gt;IL）](http://www.cnblogs.com/whitewolf/archive/2011/07/26/2117661.html)和[浅谈VS编译自定义编译任务&#8212;MSBuild Task(csproject)](http://www.cnblogs.com/whitewolf/archive/2011/07/27/2119005.html)，在第一篇中我们简单研究了c#语法糖和PostSharp的MSIl注入，紧接第二篇中我们介绍了自定义MSBuild编译任务（记得有位老兄发链接用 MSBuild自动发布Silverlight xap ，我想说的我做的是自定义编译任务，不是什么发布，MSBuild本就是一个发布工具）。之所以在此前介绍编译Task是因为我讲介绍的就是利用MSBuild和MSILInject制作静态注入式AOP，想成熟的产品PostSharp，当然我也不会去重造轮子，但需要明白起原理和自动化注入时机。废话不多说，今天将请出我们的MSIL注入的好东西：Mono.Cecil.官方网站[http://www.mono-project.com/Cecil](http://www.mono-project.com/Cecil "http://www.mono-project.com/Cecil")，他是一个强大的MSIL 注入工具，在我们的Reflector插件Reflexil（动态修改程序集插件，很好用，我已经尝试多次）就有他的身影出现。还有如大名鼎鼎的[SharpDevelop](http://www.icsharpcode.net/OpenSource/SD/)，[LINQPad](http://www.linqpad.net/)，[Ja.NET](http://www.janetdev.org/)等等（可以参见[https://github.com/jbevain/cecil/wiki/Users](https://github.com/jbevain/cecil/wiki/Users "https://github.com/jbevain/cecil/wiki/Users")）。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在本节我们需要看看这个Mono.Cecil，先来一个简单的认识。

我来在我们的方法执行前后加入我们的输出信息：

原来代码：


     class Program 
       { 
           static void Main(string[] args) 
           { 
               Console.WriteLine("破浪Blog：http://www.cnblogs.com/whitewolf/"); 
           } 
       }

任务：

1我将在方法执行前后添加一个Console.WriteLine("Method start&#8230;");

2方法最后添加Console.WriteLine("Method finish&#8230;&#8220;）；

具体Mono.Cecil Code：

    using System; 
      using System.Collections.Generic; 
      using System.Linq; 
      using System.Text; 
      using Mono.Cecil; 
      using Mono.Cecil.Cil; 

      namespace BlogSample 
      { 
          class Program 
          { 
              static void Main(string[] args) 
              { 
                  AssemblyDefinition assembiy = AssemblyFactory.GetAssembly(args[0]); 
                  foreach (Mono.Cecil.TypeDefinition item in assembiy.MainModule.Types) 
                  { 
                      foreach (MethodDefinition method in item.Methods) 
                      { 
                          if (method.Name.Equals("Main")) 
                          { 

                              var ins = method.Body.Instructions[0]; 
                              var worker = method.Body.CilWorker; 
                              worker.InsertBefore(ins, worker.Create(OpCodes.Ldstr, "Method start…")); 
                              worker.InsertBefore(ins, worker.Create(OpCodes.Call, 
                                  assembiy.MainModule.Import(typeof(Console).GetMethod("WriteLine", new Type[] { typeof(string) })))); 
                              ins = method.Body.Instructions[method.Body.Instructions.Count - 1]; 

                              worker.InsertBefore(ins, worker.Create(OpCodes.Ldstr, "Method finish…")); 
                              worker.InsertBefore(ins, worker.Create(OpCodes.Call, 
                                  assembiy.MainModule.Import(typeof(Console).GetMethod("WriteLine", new Type[] { typeof(string) })))); 
                              break; 
                          } 
                      } 

                  } 

                  AssemblyFactory.SaveAssembly(assembiy, "IL_" + args[0]); 
                  Console.Read(); 
              } 
          } 
      }

DOS运行结果：

![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201107/201107282128456040.jpg "无标题")

我们在来看看反编译后的MSIL

![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201107/201107282128509350.png "image")
C#：

![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201107/201107282128529675.png "image")
&nbsp;&nbsp;&nbsp; 在这最后我们可以想一下，如果我们利用Mono.Cecil可以干些什么事情，能做的当然很多，我首先想尝试的了与上一节[浅谈VS编译自定义编译任务&#8212;MSBuild Task(csproject)](http://www.cnblogs.com/whitewolf/archive/2011/07/27/2119005.html)结合PostSharp一样的静态注入AOP框架。还能做什么的就要靠大家发挥大家聪明的才智。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/07/28/2119969.html "原文首发")