---
layout: post
title: "(翻译)31天Windows Phone学习-1-项目模板"
description: "(翻译)31天Windows Phone学习-1-项目模板"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 今天在在外文网站Google关于Windows Phone 7的学习资料，无疑间Google到了[Jeff Blankenburg](http://www.jeffblankenburg.com/author/jeffblankenburg.aspx)的 [31 Days of Windows Phone](http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx) 这个系列，感觉写的比较基础和浅显易懂，适合我这种入们级的人学习，所以准备拿来对Windows Phone 7的简单入门学习。并翻译出来供像我一样的菜鸟学习，我的E文并不好，所以翻译难免会有一些不对的忘大家原谅和多多指教。说道E文又想起大学时，就是因为这个E文让我少的了一大笔奖学金，哎。翻译这个系列，也顺便提高一下我的E文吧，呵呵。

&nbsp;&nbsp; 步入正题：今天是我们Windows Phone学习的第一天，是一些关于项目模板的。

&nbsp; 首先： 在学习Windows Phone7之前我们假设你已经对Microsoft 的Silverlight有了一定的了解，如果你还不了解，你也可以参考作者的&nbsp; 20天Silverlight这个系列&nbsp; ，讲解的都是一些Silverlight的基础级知识。

&nbsp; 再者我们假设你已经安装了Microsoft 所有Windows Phone Tools，如果你没有安装，你可以从这里下载[http://developer.windowsphone.com/](http://developer.windowsphone.com/)，从这里我们会获得Visual Studio 2010 for Windows Phone和 Expression Blend 4 for&nbsp; Windows Phone。如果在你的机子已经安装了官方的正式版，你仅需要更新添加一些新的模板。

&nbsp;&nbsp; 在今天我们会预览一下Visual Studio 2010为我们的Windows Phone应用程序生成的默认模板。

![NewProject](http://www.jeffblankenburg.com/image.axd?picture=NewProject.png "NewProject")

#### <font style="font-weight: bold">Solution Explorer：</font>

下面是vs2010默认为我们生成的解决方案，我不准备详细介绍各个文件，你可以从<a target="_blank"><a href="http://bit.ly/8XcWaO"><font color="#3d81ee">安装上所有Tools</font></a>&nbsp;</a>并自己尝试，比较简单。

#### ![SolutionExplorer](http://www.jeffblankenburg.com/image.axd?picture=SolutionExplorer.png "SolutionExplorer")

#### <font style="font-weight: bold">ApplicationIcon.png:</font>

&nbsp; 是Phone application List现实的图标，你也可以替换成你想要的图标。

#### <font style="font-weight: bold">App.xaml：</font>

#### &nbsp; 有点像ASP.NET web.config 文件，保存了我们应用程序的常用数据和设置，我更喜欢防止我的style在这里，但这不是必须的。

#### <font style="font-weight: bold">App.xaml.cs：</font>

是前一文件（App.xaml）的Code-Behind文件，和前一个文件一起定义我们应用程序的入口点，初始化应用程序级别的全局静态资源(StaticResource)和启动程序的页面。

#### <font style="font-weight: bold">AssemblyInfo.cs：</font>

定义了我们应用程序的程序集信息，入 版本，名称等。个人觉得和我们的WinForm、Asp.net程序应该差不多。

#### <font style="font-weight: bold">Background.png：</font>

是我们应用程启动时的屏幕背景，我们也可以替换为你需要的图标。

#### <font style="font-weight: bold">MainPage.xaml：</font>

是我们应用程序启动的默认页面，这只是一个一般习惯，我们也可以在WMAppManifest.xml 中修改：
<pre>&lt;Tasks&gt;</pre><pre>       &lt;DefaultTask  Name ="_default" NavigationPage="MainPage.xaml"/&gt;    </pre><pre> &lt;/Tasks&gt;</pre>

#### <font style="font-weight: bold">MainPage.xaml.cs：</font>

前一个文件(MainPage.xaml)的Code-Behind文件，在这里需要我们编辑页面启动页面的Code.

#### <font style="font-weight: bold">SplashScreenImage.jpg:</font>

应用程序加载图标（即：我的应用程序启动，第一个页面还没有显示时）。我们也可以替换这个图标。在这里只是为了让我们的用户了解程序正在加载。

#### <font style="font-weight: bold">WMAppManifest.xml：</font>

用于定义我们应用程序打包的文件(manifest)。 Silverlight程序最终会打成xap包（zip格式），里面包含了程序需要用到的所有资源（例如图片，声音文件等等），和依赖 的第三方DLL等等。AppManifest.xml文件用于定义打包的结构。

&nbsp;

第一天学习很简单，就到这里的作者给我们提供了Code下载，其实我觉得没有必要。所以偷个懒了。

本文E文原文：[http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx](http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx "http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx")

关于Windows Phone的一些学习资料：

1：首先是翻译的原文：&nbsp;[Jeff Blankenburg](http://www.jeffblankenburg.com/author/jeffblankenburg.aspx)博客[http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx](http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx "http://www.jeffblankenburg.com/post/31-Days-of-Windows-Phone-7c-Day-1-Project-Template.aspx")

2: 园友[306Room](#)的一起学Windows Phone系列[http://www.cnblogs.com/randylee/category/258713.html](http://www.cnblogs.com/randylee/category/258713.html "http://www.cnblogs.com/randylee/category/258713.html")

3：[http://windowsteamblog.com/windows_phone/](http://windowsteamblog.com/windows_phone/ "http://windowsteamblog.com/windows_phone/")

4：[http://create.msdn.com/en-US/](http://create.msdn.com/en-US/ "http://create.msdn.com/en-US/")

还有其他的我在后续看见了，也会一一不上。也希望大家给我提供一些学习资料，共同进步。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/11/10/1873273.html "原文首发")