---
layout: post
title: "Windows服务中Timer组件"
description: "Windows服务中Timer组件"
category: cnblogs
tags: [code,cnblogs]
---
制作Windows服务时候的Timer控件并不是在工具箱上直接拖拽过来的Timer，那是System.Windows.Forms命名空间下的组件，而我们这里使用的Timer应该是System.Timers.Timer.

&nbsp; 解决方法有：

打开"工具箱"---右键---"选择项"---找到Timer控件,看好了,这个Timer控件的是system.Timer下的.可不是System.Windows.Form.然后添加.![](http://images.cnblogs.com/cnblogs_com/wxukie/timer.jpg)

&nbsp;

我选择的是直接用code书写初始化代码。因为添加项速度真的太慢了，呵呵。

MSDN上关于Timer如下：

&nbsp;

**Timer** 组件是基于服务器的计时器，它使您能够指定在应用程序中引发 [<font color="#1364c4">Elapsed</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.elapsed(v=VS.80).aspx) 事件的周期性间隔。然后可以操控此事件以提供定期处理。例如，假设您有一台关键性服务器，必须每周 7 天、每天 24 小时都保持运行。可以创建一个使用 **Timer** 的服务，以定期检查服务器并确保系统开启并在运行。如果系统不响应，则该服务可以尝试重新启动服务器或通知管理员。

基于服务器的 **Timer** 是为在多线程环境中用于辅助线程而设计的。服务器计时器可以在线程间移动来处理引发的 **Elapsed** 事件，这样就可以比 Windows 计时器更精确地按时引发事件。有关基于服务器的计时器的更多信息，请参见&#8220;[<font color="#1364c4">基于服务器的计时器介绍</font>](http://msdn.microsoft.com/zh-cn/library/tb9yt5e6(v=VS.80).aspx)&#8221;。

基于 [<font color="#1364c4">Interval</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.interval(v=VS.80).aspx) 属性的值，**Timer** 组件引发 **Elapsed** 事件。可以处理该事件以执行所需的处理。例如，假设您有一个联机销售应用程序，它不断向数据库发送销售订单。编译发货指令的服务分批处理订单，而不是分别处理每个订单。可以使用 **Timer** 每 30 分钟启动一次批处理。

注意:

当 [<font color="#1364c4">AutoReset</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.autoreset(v=VS.80).aspx) 设置为 **false** 时，**Timer** 只在第一个 **Interval** 过后引发一次 **Elapsed** 事件。若要保持以 **Interval** 时间间隔引发 **Elapsed** 事件，请将 **AutoReset** 设置为 **true**。
</td></tr></tbody></table></div>

**Elapsed** 事件在 [<font color="#1364c4">ThreadPool</font>](http://msdn.microsoft.com/zh-cn/library/system.threading.threadpool(v=VS.80).aspx) 线程上引发。如果 **Elapsed** 事件的处理时间比 **Interval** 长，在另一个 **ThreadPool** 线程上将会再次引发���事件。因此，事件处理程序应当是可重入的。

注意:

在一个线程调用 [<font color="#1364c4">Stop</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.stop(v=VS.80).aspx) 方法或将 [<font color="#1364c4">Enabled</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.enabled(v=VS.80).aspx) 属性设置为 **false** 的同时，可在另一个线程上运行事件处理方法。这可能导致在计时器停止之后引发 **Elapsed** 事件。**Stop** 方法的示例代码演示了一种避免此争用条件的方法。
</td></tr></tbody></table></div>

如果和用户界面元素（如窗体或控件）一起使用 **Timer**，请将包含有 **Timer** 的窗体或控件赋值给 [<font color="#1364c4">SynchronizingObject</font>](http://msdn.microsoft.com/zh-cn/library/system.timers.timer.synchronizingobject(v=VS.80).aspx) 属性，以便将此事件封送到用户界面线程中。 

**Timer** 在运行时是不可见的。

<span class="LW_CollapsibleArea_Title">示例</span> 

<div class="LW_CollapsibleArea_HrDiv">

* * *

</div>

<a name="codeExampleToggle" xmlns="http://www.w3.org/1999/xhtml"></a>

下面的示例创建一个 **Timer**，它每隔五秒钟在控制台上显示一次&#8220;Hello World!&#8221;。

&nbsp;

	using System;
	using System.Timers;

	public class Timer1
	{
   	 	public static void Main()
   	 	{
       	 // Normally, the timer is declared at the class level, so
       	 // that it doesn't go out of scope when the method ends.
        // In this example, the timer is needed only while Main 
        // is executing. However, KeepAlive must be used at the
        // end of Main, to prevent the JIT compiler from allowing 
        // aggressive garbage collection to occur before Main 
        // ends.
        System.Timers.Timer aTimer = new System.Timers.Timer();

        // Hook up the Elapsed event for the timer.
        aTimer.Elapsed += new ElapsedEventHandler(OnTimedEvent);

        // Set the Interval to 2 seconds (2000 milliseconds).
        aTimer.Interval = 2000;
        aTimer.Enabled = true;
 
        Console.WriteLine("Press the Enter key to exit the program.");
        Console.ReadLine();

        // Keep the timer alive until the end of Main.
        GC.KeepAlive(aTimer);
    }
 
    // Specify what you want to happen when the Elapsed event is 
    // raised.
    private static void OnTimedEvent(object source, ElapsedEventArgs e)
    {
        Console.WriteLine("Hello World!");
    }
}
&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/08/25/1808002.html "原文首发")