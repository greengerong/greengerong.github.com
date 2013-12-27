---
layout: post
title: "记录几种窗体出现方式（win32API）"
description: "记录几种窗体出现方式（win32API）"
category: cnblogs
tags: [code,cnblogs]
---
窗体的几种出现方式：

public const Int32 AW_HOR_POSITIVE = 0x00000001;

                    public const Int32 AW_HOR_NEGATIVE = 0x00000002;

                    public const Int32 AW_VER_POSITIVE = 0x00000004;

                    public const Int32 AW_VER_NEGATIVE = 0x00000008;

                    public const Int32 AW_CENTER = 0x00000010;

                    public const Int32 AW_HIDE = 0x00010000;

                    public const Int32 AW_ACTIVATE = 0x00020000;

                    public const Int32 AW_SLIDE = 0x00040000;

                    public const Int32 AW_BLEND = 0x00080000;

                    [DllImport("user32.dll", CharSet = CharSet.Auto)]

                    public static extern bool AnimateWindow(

                        IntPtr hwnd,  // handle to window   

                        int dwTime, // duration of animation   

                        int dwFlags // animation type   

                    );

         

        AW_ACTIVATE = 0x00020000; //平常窗体出的方式,即突发式

         

        AW_BLEND = 0x00080000; //渐入式，由透明逐渐出现

         

        AW_CENTER = 0x00000010; //由中心逐渐出现

         

        AW_HIDE = 0x00010000；//没有发现有什么特别的地方，好像也是突发出现

         

        AW_HOR_NEGATIVE = 0x00000002;//由右至左渐出

         

        AW_HOR_POSITIVE = 0x00000001;//由左至右渐出

         

        AW_SLIDE = 0x00040000;//未发现特殊效果，只看到是突发式

         

        AW_VER_NEGATIVE = 0x00000008//由下到上渐出

         

        AW_VER_POSITIVE = 0x00000004;//出上到下渐出
        
        

本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/12/04/1617257.html "原文首发")