---
layout: post
title: "System.Diagnostics命名空间里的Debug类和Trace类的用途"
description: "System.Diagnostics命名空间里的Debug类和Trace类的用途"
category: "cnblogs"
tags: [c#,cnblogs]
---
# &nbsp;

System.Diagnostics命名空间里的Debug类和Trace类的用途
摘要
在 .NET 类库中有一个 System.Diagnostics 命名空间，该命名空间提供了一些与系统进程、事件日志、和性能计数器进行交互的类库。当中包括了两个对开发人员而言十分有用的类——Debug类和Trace类。本文介绍了这两个类的一些基本用途，旨在提高广大开发人员的开发效率。
目录
使用Debug类来帮助调试
Debug类和Trace类的区别
使用Trace类来做程序日志
小结
参考资料
使用Debug类来帮助调试
调试程序对每个程序员来说是家常便饭。可是我们会经常遇到一些情况让我们头疼，例如：
当我们在开发一个界面控件的时候，简单的设断点会增加Paint事件的响应次数，而造成的环境参数改变。
断点设多了，程序常常停在正常运行的地方；这样一来，调试一个错误要花费大量时间去寻找错误。
这时，我们就需要利用System.Diagnostics.Debug类来帮助我们调试。我们可以通过调用Debug.WriteLine(String message)函数，将我们所关心的信息打印在Visual Studio IDE的Output窗口中。也可以利用Debug.Assert(bool condition)来让程序停在错误的地方，并且显示Call stack。
Debug类中所有函数的调用都不会在Release版本里有效。也就是说，我们通过这种方法所加的代码可以仅用于调试；在发布的时候无需删任何代码，就可以给用户一个没有调试指令的程序了。
下面的这个例子演示了这两个函数来帮助调试的方法：
1、 新建一个Visual Studio C# Project，采用默认的项目名。
2、 往Form1上拖一个label，并采用其缺省ID。
3、 在Form1.cs中的Form1类中添加下面的函数代码：

	private int time=0;
	protected override void OnPaint(PaintEventArgs e)
	{
		time++;
		this.label1.Text="OnPain called "+time.ToString()+" Times.";
	}
	protected override void OnResize(EventArgs e)
	{
		System.Diagnostics.Debug.Assert(this.Width>200,"Width should be larger than 200.");
		System.Diagnostics.Debug.WriteLine(Size.ToString());
	}

4、 编译并运行项目的Debug版本。
5、 切换Visual Studio .NET IDE到Output窗口。
6、 切换到刚才的程序，改变主窗口的大小，您可以在IDE中看到Form1窗口的实时大小，并在Form1上看到OnPaint被调用的次数。当窗口的宽度小于等于200个像素的时候，系统会弹出一个Assertion Fail的对话框。里面显示了当前程序的Call Stack。如果您在OnPaint中设置了断点，想要调试程序的话，那么您会进入一个死循环，直到您停止调试。


Debug类和Trace类的区别
您一定发现了在System.Diagnostics命名空间中还有一个名为Trace的类。它的函数功能和Debug非常相似。为什么要有这样两个功能类似的类呢？
原因是这样的，Debug类里所提供的函数仅在编译时带#Debug宏参数才奏效，一旦到了Release版本中，这些函数都会被忽略。也就是说Debug类的功能仅在程序员开发的时候能用。而Trace则不同，它能在Release版本的程序中也被运行，这样程序员就可以在Release版本的程序中添加一些Debug类提供的功能了。
使用Trace类来做程序日志
接下来的问题就是：我们程序员能利用Trace类的功能做些什么呢？我们可以用它来做程序的日志。
1、 打开刚刚的project。
2、 用下面的代码覆盖刚才第2步的代码：

	private void Calculate()
		{
		int a=1,b=1;
		try
		{
		System.Random r = new Random();
		while (true)
		{
		a=(int)(r.NextDouble()*10);
		b=(int)(r.NextDouble()*10);
		System.Diagnostics.Trace.WriteLine(System.DateTime.Now.ToString()+": "+
		a.ToString()+"/"+b.ToString()+"="+(a/b).ToString());
		}
		}
		catch (Exception ex)
		{
		System.Diagnostics.Trace.WriteLine(System.DateTime.Now.ToString()+": "+a.ToString()+
		"/"+b.ToString()+"="+" ERROR: "+ex.Message);
		MessageBox.Show(ex.Message);
		}
		}
		

3、 在构造函数Form1()的最后添加下面的代码，将Trace的输出重定向到app.log文件中：

	System.Diagnostics.Trace.Listeners.Clear();
	System.Diagnostics.Trace.AutoFlush=true;
	System.Diagnostics.Trace.Listeners.Add(new 	System.Diagnostics.TextWriterTraceListener("app.log"));

4、 拖一个按钮到该Form上，双击按钮，在button1_Click函数中添加如下代码：
Calculate();
Application.Exit();
5、 运行该程序的Release版本，点击添加的按钮，程序便开始执行一位随机数除法。由于是随机数，可能会出现出数为0的情况，这样程序就会抛出Exception，这是程序会自动中止。
6、 在该程序所在的目录里您可以发现出现了一个新的文件app.log，里面记录了各个时刻的运算纪录，并把Exception纪录在日志中

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/20/1606891.html "原文首发")