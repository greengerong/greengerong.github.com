---
layout: post
title: "Wpf消息循环之消息传递"
description: "Wpf消息循环之消息传递"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 几天遇见一个问题需要检查某个wpf程序是否已经运行，如果没有运行则启动传递参数，如果已运行则需要直接传递消息。在没有运行 情况下传递参数很简单，我们只需要Process cmd窗口启动并传递参数，在程序中处理。但是如果程序已经启动有点麻烦，凭着我曾winform的经验第一时间想到的是win32 api&nbsp; SendMessage,我们的C#程序只需要DllImport就可以调用了。经过一番查找和对wpf window和DispatcherObject的Reflector，花了我大半天终于找到了System.Windows.Interop.HwndSource中有AddHock方法可以添加对win32消息机制的监听。这下就很好办了我们只需要注册MainWindow的这个时间，来监听win32消息处理我们的0x004A消息。

&nbsp;&nbsp;&nbsp; 控制台代码，主要应用的FindWindow 这个win32方法查找我们的窗体，SendMessage发送我们的消息，和winform没有什么差别，对于win32的使用你可以参考[毒龙的程序人生](http://www.cnblogs.com/speeding/) 的[关于C#中实现两个应用程序消息通讯的问题](http://www.cnblogs.com/speeding/archive/2004/10/24/56033.html)。难得查win32 Api直接copy，借来用用。

程序：


    using System; 
    using System.Collections.Generic; 
    using System.Linq; 
    using System.Text; 
    using System.Runtime.InteropServices; 

    namespace ConsoleApplication1 
    { 
        class Program 
        { 
            static void Main(string[] args) 
            { 
                string ch = ""; 
                while (ch.ToLower() != "q") 
                { 

                    if (!SendMessage("Window1", @"Hello,I am from Console Program:" + ch)) 
                    { 
                       Console.WriteLine("no window");

                    }; 
                    ch = Console.ReadLine(); 
                } 
            } 

            public static bool SendMessage(string windowName, string strMsg) 
            { 
                if (strMsg == null) return true; 
                IntPtr hwnd = (IntPtr)FindWindow(null, windowName   ); 
                if (hwnd != IntPtr.Zero) 
                { 
                    CopyDataStruct cds; 
                    cds.dwData = IntPtr.Zero; 
                    cds.lpData = strMsg; 
                    cds.cbData = System.Text.Encoding.Default.GetBytes(strMsg).Length + 1; 
                    int fromWindowHandler = 0; 
                    SendMessage(hwnd, 0x004A, fromWindowHandler, ref  cds); 
                    return true; 
                } 
                return false; 
            } 

            [DllImport("User32.dll", EntryPoint = "FindWindow")] 
            private static extern int FindWindow(string lpClassName, string lpWindowName); 

            [DllImport("User32.dll", EntryPoint = "SendMessage")] 

            private static extern int SendMessage 

            ( 

            IntPtr hWnd, 

            int Msg, 

            int wParam, 

            ref  CopyDataStruct lParam 

            ); 

        } 

        [StructLayout(LayoutKind.Sequential)] 

        public struct CopyDataStruct 
        { 

            public IntPtr dwData; 

            public int cbData; 

            [MarshalAs(UnmanagedType.LPStr)] 

            public string lpData; 

        } 

    }

&nbsp;wpf端程序：主要需要在MainWindow中loaded事件订阅消息监听：这里需要System.Windows.Interop.HwndSource的AddHock方法注册
程序：

 

      IntPtr WndProc(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled) 
             { 

                 if (msg == 0x004A) 
                 { 

                     CopyDataStruct cds = (CopyDataStruct)System.Runtime.InteropServices.Marshal.PtrToStructure(lParam, typeof(CopyDataStruct)); 

                     MessageBox.Show(cds.lpData); 
                     this.Visibility = Visibility.Visible; 
                 } 

                 return hwnd; 

             } 

             private void Window_Loaded(object sender, RoutedEventArgs e) 
             {           

                 (PresentationSource.FromVisual(this) as System.Windows.Interop.HwndSource).AddHook(new System.Windows.Interop.HwndSourceHook(WndProc)); 
             }

截个图：

[![GDVCJ_1PZO7SU((~1}41XSG](http://images.cnblogs.com/cnblogs_com/whitewolf/201103/201103042248334156.jpg "GDVCJ_1PZO7SU((~1}41XSG")](http://images.cnblogs.com/cnblogs_com/whitewolf/201103/201103042248312846.jpg)

很简单的东西结果被MS封装的不知哪里去，让我查了半天（其实应该是我的无知吧，不管怎么解决了就是心情舒畅了）；

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/03/04/1971300.html "原文首发")