---
layout: post
title: "AOP之PostSharp3-MethodInterceptionAspect"
description: "AOP之PostSharp3-MethodInterceptionAspect"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp; 在上两篇我们介绍了[OnExceptionAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)和[OnMethodBoundaryAspect](http://www.cnblogs.com/whitewolf/archive/2011/12/04/2275680.html) ，在这节我们将继续了解MethodInterceptionAspect，他为我们提供了关于方法处理的AOP切入，不同于OnMethodBoundaryAspect，他不是边界，是方法体。有了我们可以在我们的方法切入aspect很多有用的信息，比如将同步方法变为异步，防止多次点击重复提交，winform，wpf的多线程调用UI（参见[PostSharp - Thread Dispatching（GUI多线程）](http://www.cnblogs.com/whitewolf/archive/2011/08/18/2144153.html)），长时间操作在超过用户接受时间弹出进度条等等有用的关于用户体验和业务逻辑功能，简化我们的编程开发。

同样我们先来看看其MethodInterceptionAspect定义：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346096618.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346079947.png) 

Invoke MethodInterceptionArgs参数：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346153482.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346138763.png) 

我们一般使用Proceed是的方法进行处理。在这时我们可以加入线程池调用，使的其变为异步操作。

同时MethodInterceptionAspect 还继承了MethodLevelAspect 的CompileTimeValidate编译是验证，CompileTimeInitialize编译时初始化，RuntimeInitialize运行时初始化，后边的初始化我们将在后面一节PostSharp范围（static和instance中讲到）。

其定义很简单，在于我们的发挥：

二：防止多次提交处理demo：

我们这里只采用简单思路在方法进入禁止按钮可用，方法执行完成后恢复可用状态。我们将使监听winform事件处理方法，按钮来自EventHandle的第一个参数Sender。

    [Serializable] 
        public class UnMutipleTriggerAttribute : MethodInterceptionAspect 
        { 
           

    public override bool CompileTimeValidate(System.Reflection.MethodBase method) 
           { 
               var ps = method.GetParameters(); 
               if (ps != null && ps.Count() > 0 && ps[0].Name == "sender") 
                   return true; 
               return false; 
           } 

            public override void OnInvoke(MethodInterceptionArgs args) 
            { 
                if (args.Arguments.Count > 0) 
                { 
                    var controls = args.Arguments[0] as System.Windows.Forms.Control; 
                    if (controls != null && controls.Enabled) 
                    { 
                        controls.Enabled = false; 
                        args.Proceed(); ; 
                        controls.Enabled = true; 
                    } 
                } 

            } 
        }

在这里我们是监听方法的处理事件函数根据vs自动生成规则，第一个参数是sender，事件源，这里利用了CompileTimeValidate在编译时决定是否注入aspect。

注意这里只是一个简单的demo，只针对于同步操作，如要变为异步操作，这需要改为在异步操作后启用。

测试在button点击方法加上attribute：

     [UnMutipleTriggerAttribute] 
          private void Save(object sender, EventArgs e) 
          { 
              System.Threading.Thread.Sleep(2000); 
          }

效果：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346178857.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112042346163416.png) 

这个例子很简单的就完成了。

[demo下载](http://files.cnblogs.com/whitewolf/PostSharpDemo.rar "Demo下载")

参考：

1. [<font color="#3d81ee">AOP之PostSharp初见-OnExceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
2. [<font color="#3d81ee">AOP之PostSharp2-OnMethodBoundaryAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
3. [<font color="#3d81ee">AOP之PostSharp3-MethodInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
4. [<font color="#6699cc">AOP之PostSharp4-实现类INotifyPropertyChanged植入</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
5. [<font color="#6699cc">AOP之PostSharp5-LocationInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
6.  [<font color="#6699cc">AOP之PostSharp6-EventInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
7.   [<font color="#3d81ee">http://www.cnblogs.com/whitewolf/category/312638.html</font>](http://www.cnblogs.com/whitewolf/category/312638.html) 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html "原文首发")