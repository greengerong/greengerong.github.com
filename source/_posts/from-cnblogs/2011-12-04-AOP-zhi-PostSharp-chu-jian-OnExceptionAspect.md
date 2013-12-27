---
layout: post
title: "AOP之PostSharp初见-OnExceptionAspect"
description: "AOP之PostSharp初见-OnExceptionAspect"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; PostSharp 这个静态植入的aop框架我就不多说了，在以前的aop文件，我们也尝试用[MSBuild+Mono.Cicel](http://www.cnblogs.com/whitewolf/category/312638.html)理解静态植入AOP的原理。最近公司准备购买Postsharp做一些AOP，减少开发是代码量，至于选择AOP相信也不用多说。我也在今天重新了解了些Postsharp最新版更新，这阵子的博客更新也少了，所以准备在[MSBuild+Mono.Cicel](http://www.cnblogs.com/whitewolf/category/312638.html)的基础上再一些Postsharp系列。今天既然是初见，那么我们就从最简单的OnExceptionAspect开始。

一：OnExceptionAspect

起定义如下：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132381812.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132372435.png) 

先写Aspect Attribute：


  	[Serializable] 
        public class ExceptionAspectDemoAttribute : OnExceptionAspect 
        { 

            public override void OnException(MethodExecutionArgs args) 
            { 
                var msg = string.Format("时间[{0:yyyy年MM月dd日 HH时mm分}]方法{1}发生异常: {2}\n{3}", DateTime.Now, args.Method.Name, args.Exception.Message, args.Exception.StackTrace); 
                Console.WriteLine(msg); 
                args.FlowBehavior = FlowBehavior.Continue; 
            } 
            public override Type GetExceptionType(System.Reflection.MethodBase targetMethod) 
            { 
                return typeof(NullReferenceException); 
            } 
        }

注意Postsharp的Aspect都需要标记为可序列化的，因为在编译时会为我们二进制序列化为资源，减少在运行是的开销，这个将在后面专门讲。

上面的code继承至OnExceptionAspect，并且override OnException和GetExceptionType，GetExceptionType为我们需要处理的特定异常。OnException为异常处理决策方法。我们的异常处理决策是当NullReferenceException时候我们会记录日志，并且方法指定继续（args.FlowBehavior = FlowBehavior.Continue）。

看看我们的测试代码：

     class Program 
       { 
           static void Main(string[] args) 
           { 
               Program.ExceptionAspectDemoAttribute1(); 
               Program.ExceptionAspectDemoAttribute2(); 
               Console.Read(); 
           } 
           [ExceptionAspectDemo] 
           public static void ExceptionAspectDemoAttribute1() 
           { 
               string s = null; 
               s.GetType(); 
           } 
           [ExceptionAspectDemo] 
           public static void ExceptionAspectDemoAttribute2() 
           { 
               throw new Exception("exception"); 
           } 
       }

&nbsp;很显然我们的两个方法抛出了null异常和自定义异常，预期是NullReferenceException会被扑捉，而自定义异常会中断，运行效果如下：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132436890.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/20111204013240186.png)&nbsp; 

我们在来看看postsharp为我们做了什么，当然是反编译看看：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132497243.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/20111204013246115.png) 

二：Postsharp的Multicasting

1:Multicasting class:

&nbsp; 在这随便也说一下postsharp的Multicasting，多播这样翻译感觉有点死板呵呵，理解就行。利用这一点我们可以吧我们的aspect放在class，assembly等目标上匹配我们的多个目标。比如现在我们不想在我们的每个方法上加attribute，那我们可以选择在class上，如：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132515475.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132509686.png) 

反编译，同样注入了我们每个方法：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132551142.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132524994.png) 

2:Multicasting assembly:

我们同样可以利用

[assembly: PostSharpDemo.ExceptionAspectDemoAttribute()]

标记在我们的程序集上。

3:AttributeExclude:

但是注意这样也标记了我们的aspect，某些时候可能会导致堆栈溢出 ，我们可以用AttributeExclude=true来排除。

同时我们也可以设置应用目标：AttributeTargetMemberAttributes是一个枚举类型，定义如下：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132564009.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/20111204013255520.png)

比如我们需要过滤编译时候生成的目标（自动属性，action等等），

<div class="cnblogs_code">
<div>[assembly:&nbsp;PostSharpDemo1.MethodTraceAspect(AttributeExclude&nbsp;=&nbsp;<span style="color: #0000ff">true</span>,&nbsp;AttributePriority&nbsp;=&nbsp;<span style="color: #800080">0</span>,&nbsp;AttributeTargetMemberAttributes&nbsp;=&nbsp;MulticastAttributes.CompilerGenerated)]</div></div>

&nbsp;4:AttributePriority:

还有AttributePriority，我们可以设置编译时优先级。如果我们对目标标记了多个aspect，这样postsharp就不确定注入先后顺序，这样不能确保正确性，在vs编译时候我们会看见警告：Their order of execution is undeterministic.

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040133019119.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112040132595140.png) 

这是时候AttributePriority就派上用途了来决定我们植入的先后优先级。

5:其他匹配

同上AttributeTargetMemberAttributes 我们还可以利用AttributeTargetMembers，AttributeTargetTypes进行目标名称的匹配，支持模糊匹配。

附件：[Demo下载](http://files.cnblogs.com/whitewolf/PostSharpDemo.rar "Demo下载")

我的AOP资料：

1. [<font color="#3d81ee">AOP之PostSharp初见-OnExceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
2. [<font color="#3d81ee">AOP之PostSharp2-OnMethodBoundaryAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
3. [<font color="#3d81ee">AOP之PostSharp3-MethodInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
4. [<font color="#6699cc">AOP之PostSharp4-实现类INotifyPropertyChanged植入</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
5.  [<font color="#6699cc">AOP之PostSharp5-LocationInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
6.  [<font color="#6699cc">AOP之PostSharp6-EventInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
7.   [<font color="#3d81ee">http://www.cnblogs.com/whitewolf/category/312638.html</font>](http://www.cnblogs.com/whitewolf/category/312638.html) 

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html "原文首发")