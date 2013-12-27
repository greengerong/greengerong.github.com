---
layout: post
title: "AOP之PostSharp6-EventInterceptionAspect(事件异步调用)"
description: "AOP之PostSharp6-EventInterceptionAspect(事件异步调用)"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 在上几章我们讨论了方法属性字段的aspect，现在我们再来看看事件机制的aspect。和字段，属性location一样，在c#中字段也可以转化为方法名为add，remove的方法处理，所以对于事件的aspect，同样类似于我们的方法。我们先看看EventInterceptionAspect的定义：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947198892.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947164625.png) 

aspect类包含我们对于事件aspect所必要的注册，取消，调用的注入。

其参数定义如下：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947226648.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947203069.png) 

为我们提供了，ProceedAddHandler，ProceedInvokeHandler，ProceedRemoveHandler的事件处理代理。同样包含来自AdviceArgs的Instance对象。

&nbsp; 对于事件aspect的例子真的不好想，在这里我们只是简单的做个事件变为异步调用的代码作为demo：

 	 [Serializable]
        public class AsynEventAspectAttribute : PostSharp.Aspects.EventInterceptionAspect
        {

            public override void OnInvokeHandler(PostSharp.Aspects.EventInterceptionArgs args)
            {
                var th = new System.Threading.Thread(new System.Threading.ParameterizedThreadStart(new Action<object>((obj) =>
                    {
                        System.Threading.Thread.Sleep(new Random().Next(1000));
                        try
                        {
                            args.ProceedInvokeHandler();
                        }
                        catch (Exception ex)
                        {

                            args.ProceedRemoveHandler();
                        }
                    })));
                th.Start();
            }
        }

&nbsp;测试代码：

     namespace PostSharpDemo 
    { 
        public class TestAsyncAspect 
        { 
            [AsynEventAspectAttribute] 
            public event EventHandler SomeEvent = null; 

            public void OnSomeEvent() 
            { 
                if (SomeEvent != null) 
                { 

                    SomeEvent(this, EventArgs.Empty); 
                } 
            } 
        } 
    }

    class Program 
        { 
            static void Main(string[] args) 
            {

    TestAsyncAspect pro = new TestAsyncAspect(); 
              for (int i = 0; i < 10; i++) 
              { 
                  pro.SomeEvent += new EventHandler(pro_SomeEvent); 
              } 
              pro.OnSomeEvent(); 
        //      pro.SomeEvent -= new EventHandler(pro_SomeEvent); 
              Console.WriteLine("主线程完了！"); 
              Console.Read(); 
          } 

          static void pro_SomeEvent(object sender, EventArgs e) 
          { 
              Console.WriteLine(System.Threading.Thread.CurrentThread.ManagedThreadId); 
          }    

    }

&nbsp;效果图如下：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947264536.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112131947247402.png)

附件下载：[demo](http://files.cnblogs.com/whitewolf/PostSharpDemo.rar)

1. [<font color="#3d81ee">AOP之PostSharp初见-OnExceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
2. [<font color="#3d81ee">AOP之PostSharp2-OnMethodBoundaryAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
3. [<font color="#3d81ee">AOP之PostSharp3-MethodInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
4. [<font color="#6699cc">AOP之PostSharp4-实现类INotifyPropertyChanged植入</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
5. [<font color="#6699cc">AOP之PostSharp5-LocationInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
6.  [<font color="#6699cc">AOP之PostSharp6-EventInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
7.   [<font color="#3d81ee">http://www.cnblogs.com/whitewolf/category/312638.html</font>](http://www.cnblogs.com/whitewolf/category/312638.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html "原文首发")