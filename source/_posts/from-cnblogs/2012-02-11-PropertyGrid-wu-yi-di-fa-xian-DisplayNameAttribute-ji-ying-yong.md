---
layout: post
title: "PropertyGrid无意的发现DisplayNameAttribute及应用"
description: "PropertyGrid无意的发现DisplayNameAttribute及应用"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 说到这个winform属性控件[PropertyGrid](http://msdn.microsoft.com/zh-cn/library/system.windows.forms.propertygrid(v=vs.80).aspx)，要从以前参与项目架构研发，做报表引擎开始，当时我们的目的是想做一个比较简单的报表引擎没有RDLC等报表复杂，是为了让我们的可以操作，用户可以凭借表单拖拽设置样式完成报表模板设置，与我们开发人员代码实现的数据流结合，产生基于apose.cells的excel报表。把我们多而烦的报表业务交给用户完成，用户利用报表设计完成的模板保存为xml保存至服务器，工以后使用。当时做到表单控件属性设计无疑我们采用了[PropertyGrid](http://msdn.microsoft.com/zh-cn/library/system.windows.forms.propertygrid(v=vs.80).aspx)控件，[PropertyGrid](http://msdn.microsoft.com/zh-cn/library/system.windows.forms.propertygrid(v=vs.80).aspx)支持很多的控件设计时交互，很强大，但是对于控件的属性汉化却存在问题，当时也没仔细查阅msdn，直接让控件属性为中文字段设计完成，对用户提示。最后项目基本完成，能够应对简单报表，稍微减少了些开发工作量吧。

&nbsp;&nbsp;&nbsp;&nbsp; 在时隔今天做基本控件的封装的时候突然看见了System.ComponentModel.DisplayNameAttribute这个标签，见名就考虑是做什么的，查询msdn才知道他就可以完成对[PropertyGrid](http://msdn.microsoft.com/zh-cn/library/system.windows.forms.propertygrid(v=vs.80).aspx )的现实名称修改（[http://msdn.microsoft.com/zh-cn/library/system.componentmodel.displaynameattribute(v=VS.80).aspx?TPSecNotice](http://msdn.microsoft.com/zh-cn/library/system.componentmodel.displaynameattribute(v=VS.80).aspx?TPSecNotice "http://msdn.microsoft.com/zh-cn/library/system.componentmodel.displaynameattribute(v=VS.80).aspx?TPSecNotice")）。于是便尝试了一下。

代码：


	        using System; 
        using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 

        namespace WindowsFormsApplication1 
        { 
            class TestControl : System.Windows.Forms.TextBox, Green.SmartUIControls.ISmartUIControl 
            { 
                [System.ComponentModel.Browsable(true)] 
                [System.ComponentModel.DefaultValue(null)] 
                [System.ComponentModel.Description("数据绑定匹配属性")] 
                [System.ComponentModel.Category("Green.SmartUIControl")] 
                [System.ComponentModel.DisplayName(ControlResource.Data)] 
                public string Data 
                { get; set; } 

                #region ISmartUIControl 成员 
                private Green.SmartUIControls.IDataBindSetting _DataBindSetting; 
                [System.ComponentModel.Browsable(false)] 
                public Green.SmartUIControls.IDataBindSetting DataBindSetting 
                { 
                    get 
                    { 
                        if (_DataBindSetting == null && !this.DesignMode) 
                        { 
                            _DataBindSetting = new Green.SmartUIControls.DefaultDataBindSetting(this); 
                        } 
                        return _DataBindSetting; 
                    } 
                    set 
                    { 
                        if (value != null) 
                        { 
                            _DataBindSetting = value; 
                        } 
                    } 
                } 
                [System.ComponentModel.Browsable(true)] 
                [System.ComponentModel.DefaultValue(null)] 
                [System.ComponentModel.Description("数据绑定匹配属性")] 
                [System.ComponentModel.Category("Green.SmartUIControl")] 
                [System.ComponentModel.DisplayName(ControlResource.DataBindProperty)] 
                public string DataBindProperty 
                { 
                    get; 
                    set; 
                } 

                [System.ComponentModel.Browsable(true)] 
                [System.ComponentModel.DefaultValue(null)] 
                [System.ComponentModel.Description("Dock")] 
                [System.ComponentModel.Category("Green.SmartUIControl")] 
                [System.ComponentModel.DisplayName(ControlResource.Dock)] 
                public override System.Windows.Forms.DockStyle Dock 
                { 
                    get 
                    { 
                        return base.Dock; 
                    } 
                    set 
                    { 
                        base.Dock = value; 
                    } 
                } 
                #endregion 
            } 

            public class ControlResource 
            { 
        #if Debug 
                public const string Dock = "Dock"; 
                public const string DataBindProperty = "DataBindProperty"; 
                public const string Data = "Data"; 
        #else 

                public const string Dock = "停靠"; 
                public const string DataBindProperty = "数据绑定匹配属性"; 
                public const string Data = "数据"; 
        #endif 
            } 
        }

&nbsp;&nbsp;&nbsp; 最后需要特别说明的是对于Attribute我们只能传入常量。在我们的很多开发员使用控件等时候我们也许都习惯了英文对于中文不适应了，但是我们可以利用vs的条件编译绕过，编译出不同的dll包，开发版和用户使用版本。如上面的对于调试和发布版的显示设置。这个ControlResource我们可以开发一个简单的工具对其xml保存并生成我们需要的代码维护。

看图：

设置Dock=Top：

[![QQ截图未命名2](http://images.cnblogs.com/cnblogs_com/whitewolf/201202/201202112126241645.png "QQ截图未命名2")](http://images.cnblogs.com/cnblogs_com/whitewolf/201202/201202112126194804.png) 

设置Dock=Bottom：

[![QQ截图未命名](http://images.cnblogs.com/cnblogs_com/whitewolf/201202/201202112126261909.png "QQ截图未命名")](http://images.cnblogs.com/cnblogs_com/whitewolf/201202/201202112126254842.png) 

&nbsp;&nbsp;&nbsp; 同时我也考虑到在我们的工作流自定义表单设计和代码生成工具等中我们也可以运用，表单设计的控件字段属性设置，保存为xml或者二级制，xaml存储之类。简单说一句对于silverlight，wpf 的对于我觉得保存为xaml是最简单的，我们可以直接保存xaml，并简单转换加入父容器中。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/02/11/2347096.html "原文首发")