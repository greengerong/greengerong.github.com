---
layout: post
title: "简介Gulp, Grunt, Bower, 和 npm 对Visual Studio的支持"
date: 2014-10-07 12:18:24 +0800
comments: true
categories: [grunt,glup,bower,npm,vs]
---

 [原文发表地址][Introducing Gulp, Grunt, Bower, and npm support for Visual Studio](http://www.hanselman.com/blog/IntroducingGulpGruntBowerAndNpmSupportForVisualStudio.aspx)

Web 开发，特别是前端 Web 开发，正迅速变得像传统的后端开发一样复杂和精密。**大多数项目不仅仅是通过** FTP上传一些 JS 和 CSS 文件。而现在的**前端生成过程，**可以囊括SASS 和LESS扩展、CSS/JS的压缩包、JSHint 或 JSLint的运行时 、或者更多。这些生成任务和进程都和像Gulp和Grunt这样的工具一起协调工作。此外，类似于npm和bower这样的管理系统将客户端库作为软件包来管理。

##### ASP.NET客户端软件包的管理者，为什么不用 NuGet？或MSBuild？

你们中的一些人可能会问，为什么JavaScript不使用 NuGet？为什么不扩展 MSBuild 去构建 CSS/JS？原因很简单。因为已经有了丰富的系统，来做这种事情。对于服务器端库 （和一些客户端）来说，使用NuGet 就已经很棒了。npm和bower 上已经有了很多的，而且还会有更多的 CSS 和 JS 库。而对于服务器端的应用程序构建来说，使用MSBuild很棒，但当构建客户端应用程序时，它有些多余了。

所以，两者都可以使用。这些都是您工具包中的工具。添加Gulp，Grun，Bower，npm的支持（和将来需要其他东西） ，这意味着为ASP.NET前端开发者提供了一个更熟悉的环境。它允许 ASP.NET 开发人员引入 JS 和 CSS 库，使他们可以每天使用。

##### 引入任务资源管理器

我们从你们中，以及整个社会收到了相当多的、关于Grunt/Gulp的功能请求。我们利用Visual Studio “14的充分可扩展性正在构建对Grunt/Gulp第一流的支持。现在我们已经准备好将这个支持作为VS2013的一个扩展加入到预览版本中， 并且我们感激您帮助我们测试和考察这个功能。

今天我们介绍一个预览版本，在这个预览版本中，“[任务资源管理器](http://visualstudiogallery.msdn.microsoft.com/8e1b4368-4afb-467a-bc13-9650572db708)”将作为VSIX**的一个扩展。****同时也推荐两个其他的****VSIX****来完善对这个功能的体验。**

**注意：**** ****VSIX****扩展中的大多数功能都被内置到****Visual Studio****中，因此你不需要安装其他别的东西。而且，****在****VS2013****和此预览版本中我们需要更多的****VSIX****，让你迟早能得到这些扩展。**** ****请注意，今天任务资源管理器只工作于****Vsiaual Studio Express ****版本中，但****VS14****的所有功能都将出现在****VS****免费版本中。**

类似于VS Productivity Power Tools一样， “DevLabs”这样的功能现在还在预览版中。但是他们终将会集成到最终的产品中。

##### 你需要什么？

##### 首先，你将需要[Visual Studio 2013.3](http://www.microsoft.com/en-us/download/details.aspx?id=43721) ，3的意思是免费的更新"Update 3"。

1.  [**TRX-****任务资源管理器**](http://www.microsofttranslator.com/bv.aspx?from=en&amp;to=zh-CHS&amp;a=http%3A%2F%2Fvisualstudiogallery.msdn.microsoft.com%2F8e1b4368-4afb-467a-bc13-9650572db708)** **Visual Studio 扩展
2.  [NMP/NBower包智能感知](http://www.microsofttranslator.com/bv.aspx?from=en&amp;to=zh-CHS&amp;a=http%3A%2F%2Fvisualstudiogallery.msdn.microsoft.com%2F65748cdb-4087-497e-a394-2e3449c8e61e)-搜索NPM 和Bower包在线版，它直接附加智能感知功能。
3.  可选的[Grunt Launcher](http://visualstudiogallery.msdn.microsoft.com/dcbc5325-79ef-4b72-960e-0a51ee33a0ff)（在解决方案资源管理器上右键单击选项— — 你会看到" npm install "）

    *   如果你现在没有这种扩展，那么你将需要自己运行npm install来还原/添加软件包
    *   如果你有这种扩展，那么请在运行grunt/gulp之前，右键单击 packages.json 和"npm install"

要打开 TRX （任务资源管理器），只需用鼠标右键单击您的项目中任何一个 gruntfile.js文件：

![](http://www.hanselman.com/blog/content/binary/Windows-Live-Writer/Introducing-Gulp-Grunt_E733/image002_60531aad-06cb-4ce7-83ea-5629fa7e8b8d.png)

默认情况下，TRX 位于VS的底部，，看起来像这样：

![](http://www.hanselman.com/blog/content/binary/Windows-Live-Writer/Introducing-Gulp-Grunt_E733/image001_8eae3676-2331-461b-bfe6-fec463c7f49c.png)

在这里，我们看到 gruntfile.js 在该解决方案中的一个或多个项目的根目录中。它还有**任务绑定功能，也就是说任何任务或目标可以由**** 4 ****个****不同**** Visual Studio ****事件触发。**

要想将一个任务/目标和一个VS事件绑定在一起，只需右键单击进行绑定设置。

![](http://www.hanselman.com/blog/content/binary/Windows-Live-Writer/Introducing-Gulp-Grunt_E733/image003_9d3aeb6c-f450-4e68-8d4c-010b619f7da8.png)

要想运行任何一个任务/目标，只需双击它，然后控制台将显示如下：

![](http://www.hanselman.com/blog/content/binary/Windows-Live-Writer/Introducing-Gulp-Grunt_E733/image004_1db90c39-a4cd-42a7-81df-b3ec2493e8c0.png)

当你有了软件包智能感知扩展功能时，你会发现通过bower 和 npm来直接编辑package.json很容易添加并更新软件包。

甚至，你也有了异步填充元数据工具提示功能。

![](http://www.hanselman.com/blog/content/binary/Windows-Live-Writer/Introducing-Gulp-Grunt_E733/tooltip-animated_thumb.gif)

现在你可以去测试它了，记住在你用任务资源管理器来运行Grunt任务之前，你需要运行“ npm install” 。