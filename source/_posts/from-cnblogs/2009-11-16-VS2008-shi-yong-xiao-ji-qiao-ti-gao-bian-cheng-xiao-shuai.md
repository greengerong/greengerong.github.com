---
layout: post
title: "VS2008 使用小技巧 提高编程效率"
description: "VS2008 使用小技巧 提高编程效率"
category: cnblogs
tags: [vs,cnblogs]
---
1. 怎样调整代码排版的格式？
选择：编辑—>高级—>设置文档的格式  或     编辑—>高级—>设置选中代码的格式。
格式化cs代码：Ctrl+k+f    格式化aspx代码：Ctrl+k+d

2. 怎样跳转到指定的某一行？
两种方法：Ⅰ. Ctrl+G                Ⅱ. 单击状态栏中的行号

3. 怎样创建矩形选区？
两种方法：Ⅰ. 摁住alt键，然后拖动鼠标即可。
              Ⅱ. 按住Shift+Alt点击矩形的左上和右下位置即可。

4. 怎样快速隐藏或显示当前代码段？
Ctrl+M,M

5. 怎样快速切换不同的窗口？
Ctrl+Tab

6. 怎样生成解决方案？
Ctrl+Shift+B

7. 怎样快速添加代码段？
输入prop然后按两次tab即可插入自动属性
public int MyProperty { get; set; },

(输入try,class,foreach等等，按两次tab也有类似效果。)

8. 怎样调用智能提示？
两种方法：Ⅰ. Ctrl+J              Ⅱ. Alt+→

9. 怎样调用参数信息提示？
光标放到参数名上面，然后输入Ctrl+Shif+空格。

10. 怎样查看代码的详细定义？
打开：视图—>代码定义窗口
然后你再在页面中把鼠标点到某个方法上。

11. 怎样创建区域以方便代码的阅读？
	
		#region
  			代码区域
		#endregion
	

12. 怎样同时修改多个控件的属性？
选中多个控件，然后右键属性，这个时候这些控件共有的属性就会出现，修改之后所有的控件都会变化。

13. 怎样快速添加命名空间？
对于引用了dll,但代码中没有引用其命名空间的类，输入类名后在类名上按Ctrl+.即可自动添加该类的引用命名空间语句。

14. 怎样实现快速拷贝或剪切一行？
光标只要在某行上，不用选中该行，直接按Ctrl+c 或Ctrl+x 就可以拷贝或剪切该行。

15. 怎样使用任务管理器？
假如我们开发的项目很大，在项目中有些代码没有完成，我们可以做一下标记，便于将来查找。

创建方法：在要标志的地方输入：//TODO:...内容...
使用方法：视图—>任务列表—>注释

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/16/1604035.html "原文首发")