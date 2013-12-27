---
layout: post
title: "(转)SendMessage API"
description: "(转)SendMessage API"
category: cnblogs
tags: [code,cnblogs]
---

        using System;
        using System.IO;
        using System.Threading;
        using System.Diagnostics;
        using System.Runtime.InteropServices;

        namespace XDF.GamePlugInCommon
        {
            ///   <summary>    
            ///   API   的摘要说明。    
            ///   </summary>    
            public sealed class API
            {
                //wMsg参数常量值：
                //WM_KEYDOWN 按下一个键
                public static int WM_KEYDOWN = 0x0100;
                //释放一个键
                public static int WM_KEYUP = 0x0101;
                //按下某键，并已发出WM_KEYDOWN， WM_KEYUP消息
                public static int WM_CHAR = 0x102;
                //当用translatemessage函数翻译WM_KEYUP消息时发送此消息给拥有焦点的窗口
                public static int WM_DEADCHAR = 0x103;
                //当用户按住ALT键同时按下其它键时提交此消息给拥有焦点的窗口
                public static int WM_SYSKEYDOWN = 0x104;
                //当用户释放一个键同时ALT 键还按着时提交此消息给拥有焦点的窗口
                public static int WM_SYSKEYUP = 0x105;
                //当WM_SYSKEYDOWN消息被TRANSLATEMESSAGE函数翻译后提交此消息给拥有焦点的窗口
                public static int WM_SYSCHAR = 0x106;
                //当WM_SYSKEYDOWN消息被TRANSLATEMESSAGE函数翻译后发送此消息给拥有焦点的窗口
                public static int WM_SYSDEADCHAR = 0x107;
                //在一个对话框程序被显示前发送此消息给它，通常用此消息初始化控件和执行其它任务
                public static int WM_INITDIALOG = 0x110;
                //当用户选择一条菜单命令项或当某个控件发送一条消息给它的父窗口，一个快捷键被翻译
                public static int WM_COMMAND = 0x111;
                //当用户选择窗口菜单的一条命令或//当用户选择最大化或最小化时那个窗口会收到此消息
                public static int WM_SYSCOMMAND = 0x112;
                //发生了定时器事件
                public static int WM_TIMER = 0x113;
                //当一个窗口标准水平滚动条产生一个滚动事件时发送此消息给那个窗口，也发送给拥有它的控件
                public static int WM_HSCROLL = 0x114;
                //当一个窗口标准垂直滚动条产生一个滚动事件时发送此消息给那个窗口也，发送给拥有它的控件
                public static int WM_VSCROLL = 0x115;
                //当一个菜单将要被激活时发送此消息，它发生在用户菜单条中的某项或按下某个菜单键，它允许程序在显示前更改菜单
                public static int WM_INITMENU = 0x116;
                //当一个下拉菜单或子菜单将要被激活时发送此消息，它允许程序在它显示前更改菜单，而不要改变全部
                public static int WM_INITMENUPOPUP = 0x117;
                //当用户选择一条菜单项时发送此消息给菜单的所有者（一般是窗口）
                public static int WM_MENUSELECT = 0x11F;
                //当菜单已被激活用户按下了某个键（不同于加速键），发送此消息给菜单的所有者
                public static int WM_MENUCHAR = 0x120;
                //当一个模态对话框或菜单进入空载状态时发送此消息给它的所有者，一个模态对话框或菜单进入空载状态就是在处理完一条或几条先前的消息后没有消息它的列队中等待
                public static int WM_ENTERIDLE = 0x121;
                //在windows绘制消息框前发送此消息给消息框的所有者窗口，通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置消息框的文本和背景颜色
                public static int WM_CTLCOLORMSGBOX = 0x132;
                //当一个编辑型控件将要被绘制时发送此消息给它的父窗口通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置编辑框的文本和背景颜色
                public static int WM_CTLCOLOREDIT = 0x133;

                //当一个列表框控件将要被绘制前发送此消息给它的父窗口通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置列表框的文本和背景颜色
                public static int WM_CTLCOLORLISTBOX = 0x134;
                //当一个按钮控件将要被绘制时发送此消息给它的父窗口通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置按纽的文本和背景颜色
                public static int WM_CTLCOLORBTN = 0x135;
                //当一个对话框控件将要被绘制前发送此消息给它的父窗口通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置对话框的文本背景颜色
                public static int WM_CTLCOLORDLG = 0x136;
                //当一个滚动条控件将要被绘制时发送此消息给它的父窗口通过响应这条消息，所有者窗口可以通过使用给定的相关显示设备的句柄来设置滚动条的背景颜色
                public static int WM_CTLCOLORSCROLLBAR = 0x137;
                //当一个静态控件将要被绘制时发送此消息给它的父窗口通过响应这条消息，所有者窗口可以 通过使用给定的相关显示设备的句柄来设置静态控件的文本和背景颜色
                public static int WM_CTLCOLORSTATIC = 0x138;
                //当鼠标轮子转动时发送此消息个当前有焦点的控件
                public static int WM_MOUSEWHEEL = 0x20A;
                //双击鼠标中键
                public static int WM_MBUTTONDBLCLK = 0x209;
                //释放鼠标中键
                public static int WM_MBUTTONUP = 0x208;
                //移动鼠标时发生，同WM_MOUSEFIRST
                public static int WM_MOUSEMOVE = 0x200;
                //按下鼠标左键
                public static int WM_LBUTTONDOWN = 0x201;
                //释放鼠标左键
                public static int WM_LBUTTONUP = 0x202;
                //双击鼠标左键
                public static int WM_LBUTTONDBLCLK = 0x203;
                //按下鼠标右键
                public static int WM_RBUTTONDOWN = 0x204;
                //释放鼠标右键
                public static int WM_RBUTTONUP = 0x205;
                //双击鼠标右键
                public static int WM_RBUTTONDBLCLK = 0x206;
                //按下鼠标中键
                public static int WM_MBUTTONDOWN = 0x207;

                public static int WM_USER = 0x0400;
                public static int MK_LBUTTON = 0x0001;
                public static int MK_RBUTTON = 0x0002;
                public static int MK_SHIFT = 0x0004;
                public static int MK_CONTROL = 0x0008;
                public static int MK_MBUTTON = 0x0010;
                public static int MK_XBUTTON1 = 0x0020;
                public static int MK_XBUTTON2 = 0x0040;
                //创建一个窗口
                public static int WM_CREATE = 0x01;
                //当一个窗口被破坏时发送
                public static int WM_DESTROY = 0x02;
                //移动一个窗口
                public static int WM_MOVE = 0x03;
                //改变一个窗口的大小
                public static int WM_SIZE = 0x05;
                //一个窗口被激活或失去激活状态
                public static int WM_ACTIVATE = 0x06;
                //一个窗口获得焦点
                public static int WM_SETFOCUS = 0x07;
                //一个窗口失去焦点
                public static int WM_KILLFOCUS = 0x08;
                //一个窗口改变成Enable状态
                public static int WM_ENABLE = 0x0A;
                //设置窗口是否能重画
                public static int WM_SETREDRAW = 0x0B;
                //应用程序发送此消息来设置一个窗口的文本
                public static int WM_SETTEXT = 0x0C;
                //应用程序发送此消息来复制对应窗口的文本到缓冲区
                public static int WM_GETTEXT = 0x0D;
                //得到与一个窗口有关的文本的长度（不包含空字符）
                public static int WM_GETTEXTLENGTH = 0x0E;
                //要求一个窗口重画自己
                public static int WM_PAINT = 0x0F;
                //当一个窗口或应用程序要关闭时发送一个信号
                public static int WM_CLOSE = 0x10;
                //当用户选择结束对话框或程序自己调用ExitWindows函数
                public static int WM_QUERYENDSESSION = 0x11;
                //用来结束程序运行
                public static int WM_QUIT = 0x12;
                //当用户窗口恢复以前的大小位置时，把此消息发送给某个图标
                public static int WM_QUERYOPEN = 0x13;
                //当窗口背景必须被擦除时（例在窗口改变大小时）
                public static int WM_ERASEBKGND = 0x14;
                //当系统颜色改变时，发送此消息给所有顶级窗口
                public static int WM_SYSCOLORCHANGE = 0x15;
                //当系统进程发出WM_QUERYENDSESSION消息后，此消息发送给应用程序，通知它对话是否结束
                public static int WM_ENDSESSION = 0x16;
                //当隐藏或显示窗口是发送此消息给这个窗口
                public static int WM_SHOWWINDOW = 0x18;
                //发此消息给应用程序哪个窗口是激活的，哪个是非激活的
                public static int WM_ACTIVATEAPP = 0x1C;
                //当系统的字体资源库变化时发送此消息给所有顶级窗口
                public static int WM_FONTCHANGE = 0x1D;
                //当系统的时间变化时发送此消息给所有顶级窗口
                public static int WM_TIMECHANGE = 0x1E;
                //发送此消息来取消某种正在进行的摸态（操作）
                public static int WM_CANCELMODE = 0x1F;
                //如果鼠标引起光标在某个窗口中移动且鼠标输入没有被捕获时，就发消息给某个窗口
                public static int WM_SETCURSOR = 0x20;
                //当光标在某个非激活的窗口中而用户正按着鼠标的某个键发送此消息给//当前窗口
                public static int WM_MOUSEACTIVATE = 0x21;
                //发送此消息给MDI子窗口//当用户点击此窗口的标题栏，或//当窗口被激活，移动，改变大小
                public static int WM_CHILDACTIVATE = 0x22;
                //此消息由基于计算机的训练程序发送，通过WH_JOURNALPALYBACK的hook程序分离出用户输入消息
                public static int WM_QUEUESYNC = 0x23;
                //此消息发送给窗口当它将要改变大小或位置
                public static int WM_GETMINMAXINFO = 0x24;
                //发送给最小化窗口当它图标将要被重画
                public static int WM_PAINTICON = 0x26;
                //此消息发送给某个最小化窗口，仅//当它在画图标前它的背景必须被重画
                public static int WM_ICONERASEBKGND = 0x27;
                //发送此消息给一个对话框程序去更改焦点位置
                public static int WM_NEXTDLGCTL = 0x28;
                //每当打印管理列队增加或减少一条作业时发出此消息 
                public static int WM_SPOOLERSTATUS = 0x2A;
                //当button，combobox，listbox，menu的可视外观改变时发送
                public static int WM_DRAWITEM = 0x2B;
                //当button, combo box, list box, list view control, or menu item 被创建时
                public static int WM_MEASUREITEM = 0x2C;
                //此消息有一个LBS_WANTKEYBOARDINPUT风格的发出给它的所有者来响应WM_KEYDOWN消息 
                public static int WM_VKEYTOITEM = 0x2E;
                //此消息由一个LBS_WANTKEYBOARDINPUT风格的列表框发送给他的所有者来响应WM_CHAR消息 
                public static int WM_CHARTOITEM = 0x2F;
                //当绘制文本时程序发送此消息得到控件要用的颜色
                public static int WM_SETFONT = 0x30;
                //应用程序发送此消息得到当前控件绘制文本的字体
                public static int WM_GETFONT = 0x31;
                //应用程序发送此消息让一个窗口与一个热键相关连 
                public static int WM_SETHOTKEY = 0x32;
                //应用程序发送此消息来判断热键与某个窗口是否有关联
                public static int WM_GETHOTKEY = 0x33;
                //此消息发送给最小化窗口，当此窗口将要被拖放而它的类中没有定义图标，应用程序能返回一个图标或光标的句柄，当用户拖放图标时系统显示这个图标或光标
                public static int WM_QUERYDRAGICON = 0x37;
                //发送此消息来判定combobox或listbox新增加的项的相对位置
                public static int WM_COMPAREITEM = 0x39;
                //显示内存已经很少了
                public static int WM_COMPACTING = 0x41;
                //发送此消息给那个窗口的大小和位置将要被改变时，来调用setwindowpos函数或其它窗口管理函数
                public static int WM_WINDOWPOSCHANGING = 0x46;
                //发送此消息给那个窗口的大小和位置已经被改变时，来调用setwindowpos函数或其它窗口管理函数
                public static int WM_WINDOWPOSCHANGED = 0x47;
                //当系统将要进入暂停状态时发送此消息
                public static int WM_POWER = 0x48;
                //当一个应用程序传递数据给另一个应用程序时发送此消息
                public static int WM_COPYDATA = 0x4A;
                //当某个用户取消程序日志激活状态，提交此消息给程序
                public static int WM_CANCELJOURNA = 0x4B;
                //当某个控件的某个事件已经发生或这个控件需要得到一些信息时，发送此消息给它的父窗口 
                public static int WM_NOTIFY = 0x4E;
                //当用户选择某种输入语言，或输入语言的热键改变
                public static int WM_INPUTLANGCHANGEREQUEST = 0x50;
                //当平台现场已经被改变后发送此消息给受影响的最顶级窗口
                public static int WM_INPUTLANGCHANGE = 0x51;
                //当程序已经初始化windows帮助例程时发送此消息给应用程序
                public static int WM_TCARD = 0x52;
                //此消息显示用户按下了F1，如果某个菜单是激活的，就发送此消息个此窗口关联的菜单，否则就发送给有焦点的窗口，如果//当前都没有焦点，就把此消息发送给//当前激活的窗口
                public static int WM_HELP = 0x53;
                //当用户已经登入或退出后发送此消息给所有的窗口，//当用户登入或退出时系统更新用户的具体设置信息，在用户更新设置时系统马上发送此消息
                public static int WM_USERCHANGED = 0x54;
                //公用控件，自定义控件和他们的父窗口通过此消息来判断控件是使用ANSI还是UNICODE结构
                public static int WM_NOTIFYFORMAT = 0x55;
                //当用户某个窗口中点击了一下右键就发送此消息给这个窗口
                //public static int WM_CONTEXTMENU = ??;
                //当调用SETWINDOWLONG函数将要改变一个或多个 窗口的风格时发送此消息给那个窗口
                public static int WM_STYLECHANGING = 0x7C;
                //当调用SETWINDOWLONG函数一个或多个 窗口的风格后发送此消息给那个窗口
                public static int WM_STYLECHANGED = 0x7D;
                //当显示器的分辨率改变后发送此消息给所有的窗口
                public static int WM_DISPLAYCHANGE = 0x7E;
                //此消息发送给某个窗口来返回与某个窗口有关连的大图标或小图标的句柄
                public static int WM_GETICON = 0x7F;
                //程序发送此消息让一个新的大图标或小图标与某个窗口关联
                public static int WM_SETICON = 0x80;
                //当某个窗口第一次被创建时，此消息在WM_CREATE消息发送前发送
                public static int WM_NCCREATE = 0x81;
                //此消息通知某个窗口，非客户区正在销毁 
                public static int WM_NCDESTROY = 0x82;
                //当某个窗口的客户区域必须被核算时发送此消息
                public static int WM_NCCALCSIZE = 0x83;
                //移动鼠标，按住或释放鼠标时发生
                public static int WM_NCHITTEST = 0x84;
                //程序发送此消息给某个窗口当它（窗口）的框架必须被绘制时
                public static int WM_NCPAINT = 0x85;
                //此消息发送给某个窗口仅当它的非客户区需要被改变来显示是激活还是非激活状态
                public static int WM_NCACTIVATE = 0x86;
                //发送此消息给某个与对话框程序关联的控件，widdows控制方位键和TAB键使输入进入此控件通过应
                public static int WM_GETDLGCODE = 0x87;
                //当光标在一个窗口的非客户区内移动时发送此消息给这个窗口 非客户区为：窗体的标题栏及窗 的边框体
                public static int WM_NCMOUSEMOVE = 0xA0;
                //当光标在一个窗口的非客户区同时按下鼠标左键时提交此消息
                public static int WM_NCLBUTTONDOWN = 0xA1;
                //当用户释放鼠标左键同时光标某个窗口在非客户区十发送此消息 
                public static int WM_NCLBUTTONUP = 0xA2;
                //当用户双击鼠标左键同时光标某个窗口在非客户区十发送此消息
                public static int WM_NCLBUTTONDBLCLK = 0xA3;
                //当用户按下鼠标右键同时光标又在窗口的非客户区时发送此消息
                public static int WM_NCRBUTTONDOWN = 0xA4;
                //当用户释放鼠标右键同时光标又在窗口的非客户区时发送此消息
                public static int WM_NCRBUTTONUP = 0xA5;
                //当用户双击鼠标右键同时光标某个窗口在非客户区十发送此消息
                public static int WM_NCRBUTTONDBLCLK = 0xA6;
                //当用户按下鼠标中键同时光标又在窗口的非客户区时发送此消息
                public static int WM_NCMBUTTONDOWN = 0xA7;
                //当用户释放鼠标中键同时光标又在窗口的非客户区时发送此消息
                public static int WM_NCMBUTTONUP = 0xA8;
                //当用户双击鼠标中键同时光标又在窗口的非客户区时发送此消息
                public static int WM_NCMBUTTONDBLCLK = 0xA9;

                [DllImport("user32.dll")]
                public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

                //此处主要用来让窗口置于最前(SetWindowPos(this.Handle,-1,0,0,0,0,0x4000|0x0001|0x0002);)    
                [System.Runtime.InteropServices.DllImport("user32.dll")]
                public static extern bool SetWindowPos(IntPtr hWnd,
                int hWndInsertAfter,
                int X,
                int Y,
                int cx,
                int cy,
                int uFlags
                );

                ///   <summary>    
                ///   窗口置前    
                ///   </summary>    
                ///   <param   name="hWnd"></param>    
                public static void SetWindowPos(IntPtr hWnd)
                {
                    SetWindowPos(hWnd, -1, 0, 0, 0, 0, 0x4000 | 0x0001 | 0x0002);
                }

                public static Process GetGameProcess(string processName)
                {
                    Process pro = null;
                    Process[] pros = Process.GetProcessesByName(processName);
                    if (pros.Length > 0)
                    {
                        pro = pros[0];
                    }
                    IntPtr m_WindowHandle = IntPtr.Zero;
                    m_WindowHandle = pro.MainWindowHandl; 
                    return pro;
                }
            }
        }

        //例子
        API.SendMessage(m_WindowHandle, API.WM_CLOSE, 0, 0);
        

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/12/23/1630706.html "原文首发")