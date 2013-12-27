---
layout: post
title: "VS输出窗口（output view）的小技巧--文件行号字符定位"
description: "VS输出窗口（output view）的小技巧--文件行号字符定位"
category: cnblogs
tags: [code,cnblogs]
---
在我们的调试输出到VS输出窗口的信息，有时候我们想要鼠标点击就定位该该文件，改行，甚至该列。在强大的VS工具中已经给我们提供了这个功能，我们只需要把输出到输出窗

口的字符串就是一定的格式化就可以了。c#在VS输出窗口格式为：
文件名称（行号，列号）:消息信息。
比如我 test.cs（100，78）:消息信息。就是对应我们的test.cs文件的100行78个字符。
在这里我写了一个简单异常输出信息的扩展类。
代码具体如下：&nbsp;&nbsp;&nbsp; 

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/-->public class OutPutExceptionEx
            {
                public static void WriteLine(string message, Exception ex)
                {
                    System.Diagnostics.StackTrace st = new System.Diagnostics.StackTrace(ex, true);
                    System.Diagnostics.StackFrame frm = st.GetFrame(0);
                    if (frm != null)
                    {
                        System.Diagnostics.Debug.WriteLine(string.Format("{0}({1},{2}):{3})", frm.GetFileName(), frm.GetFileLineNumber(), frm.GetFileColumnNumber(), 

        message));
                    }

                }

                public static void WriteLine(Exception ex)
                {
                    WriteLine(ex.Message, ex);
                }

                public static void Write(string message, Exception ex)
                {
                    System.Diagnostics.StackTrace st = new System.Diagnostics.StackTrace(ex, true);
                    System.Diagnostics.StackFrame frm = st.GetFrame(0);
                    if (frm != null)
                    {
                        System.Diagnostics.Debug.Write(string.Format("{0}({1},{2}):{3})", frm.GetFileName(), frm.GetFileLineNumber(), frm.GetFileColumnNumber(), 

        message));
                    }

                }

                public static void Write(Exception ex)
                {
                    Write(ex.Message,ex);
                }
            }

        //测试
            class Program
            {
                static void Main(string[] args)
                {

                    try
                    {
                        throw new Exception("这个发生了一个错误！");
                    }
                    catch (Exception ex)
                    {
                        OutPutExceptionEx.Write(ex);
                    }

                    Console.WriteLine("ok");
                    Console.Read();           
                }
        }

图片效果：

![](http://images.cnblogs.com/cnblogs_com/whitewolf/201011121051.jpg)

2：

![](http://images.cnblogs.com/cnblogs_com/whitewolf/2010111210512.jpg)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/11/12/1875473.html "原文首发")