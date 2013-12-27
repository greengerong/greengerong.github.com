---
layout: post
title: "MSBuild + MSILInect实现编译时AOP-改变前后对比"
description: "MSBuild + MSILInect实现编译时AOP-改变前后对比"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 实现静态AOP，就需要我们在预编译时期，修改IL实现对代码逻辑的修改。Mono.Cecil就是一个很好的IL解析和注入框架，参见[编译时MSIL注入--实践Mono Cecil(1)](http://www.cnblogs.com/whitewolf/archive/2011/07/28/2119969.html)。

&nbsp; 我的思路为：在编译时将加有继承制MethodInterceptBaseAttribute标签的原方法，重新组装成一个方法（并加上[[CompilerGenerated](http://www.aisto.com/roeder/dotnet/Default.aspx?Target=code://mscorlib:2.0.0.0:b77a5c561934e089/System.Runtime.CompilerServices.CompilerGeneratedAttribute/.ctor())]标签），在加入横切注入接口前后代码，调用此方法。

比如代码：

    [TestAOPAttribute(Order = 1)]

    public Class1 TestMethod1(int i, int j, Class1 c) 
            { 
                Console.WriteLine("ok"); 
                return new Class1(); 
            }

    public class TestAOPAttribute : Green.AOP.MethodInterceptBase 
        { 

            #region IMethodInject Members 

            public override bool Executeing(Green.AOP.MethodExecutionEventArgs args) 
            { 
                Console.WriteLine(this.GetType() + ":" + "Executeing"); 
                return true; 
            } 

            public override Green.AOP.ExceptionStrategy Exceptioned(Green.AOP.MethodExecutionEventArgs args) 
            { 
                Console.WriteLine(this.GetType() + ":" + "Exceptioned"); 
                return Green.AOP.ExceptionStrategy.Handle; 
            } 

            public override void ExecuteSuccess(Green.AOP.MethodExecutionEventArgs args) 
            { 
                Console.WriteLine(this.GetType() + ":" + "ExecuteSuccess"); 
            } 

            #endregion 

            #region IMethodInject Members 

                   #endregion 
        }

将会转化（实际注入IL，这里反编译为了c#代码，更清晰）为：

[![12](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313392150.png "12")](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313329255.png) 

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313416379.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313397449.png) 

从这里你就会清晰的明白这里实现静态注入了机制和原理了。我们需要做的目的就是从IL出发改变原来代码逻辑，注入我们的截取代码。使用Mono.Cecil具体代码在程序包MethodILInjectTask中。

MatchedMethodInterceptBase是应用于class上匹配该class多个methodattribute基类。rule为匹配规则。

	[TestAOP2Attribute(Rule = "TestMethod1*")]

	public class Class1 

&nbsp;&nbsp; [![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313488651.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313445558.png) 

这里需要对于继承制该基类的标示class的所有满足rule的方法进行注入。

PropertyInterceptBase：属性注入，Action属性标识get，set方法。

 	[TestAOPPropertyGetAttribute(Action = PropertyInterceptAction.Get)] 
       public int TestProperty 
       { 
           get; 
           set; 
       }


[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313565383.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201108/201108092313514766.png) 

属性注入找出标示property，更具action选择get，set方法注入IL逻辑。

现在对于方法中获取attribute通过反射，性能存在一定问题。完全可以在class中注入属性，延时加载，Dictionary类级缓存来减少这方面损失，还暂时没考虑加入。

&nbsp;&nbsp;&nbsp; 不是很会写blog，所以有什么不明白的可留言，上一篇[<font color="#3d81ee">MSBuild + MSILInect实现编译时AOP之预览</font>](http://www.cnblogs.com/whitewolf/archive/2011/08/09/2132217.html "发布于2011-08-09 14:05")，由于时间写的没头没尾的，估计大家都看的很迷茫，迷茫该怎么写。关于IL注入Mono.Cecil可以参见[编译时MSIL注入--实践Mono Cecil(1)](http://www.cnblogs.com/whitewolf/archive/2011/07/28/2119969.html)和官方[http://www.mono-project.com/Cecil](http://www.mono-project.com/Cecil)。还有必须对MSIL具有一定了解（相同与Emit的IL注入）

&nbsp;&nbsp; 附带：[源码下载](http://files.cnblogs.com/whitewolf/ConsoleApplication1.rar "源码下载")</a>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/08/09/2133106.html "原文首发")