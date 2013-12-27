---
layout: post
title: "winform 回车--&gt;Tab方法"
description: "winform 回车--&gt;Tab方法"
category: cnblogs
tags: [code,cnblogs]
---
方法有：

1. 示例

 
	if(e.KeyChar = '\r') 
 	{ 
     SendKeys.Send("{TAB}"); 
    }
    
但是 也许是我程序里处理了太多的键盘事件，用它总是反映很慢，有时候还死机。

2. 把Form的<span style="color: red">KeyPreView设为true</span>，然后在Form的KeyPress中增加下列代码即可：
 
 	private void Form1_KeyPress(object sender, 		KeyPressEventArgs e)
      	  {            
                this.SelectNextControl(this.ActiveControl, 		true, true, true, true);
        } 
        
3. 用nextControl.Focus();//nextControl 为Control；

4:Control.rocessTabKey（true）；也可以实现
方法2对于对于我这个CODE很使用，因为我的控件时动态生成的(及处理它时他的下一个控件还没产生呢)；

关于方法2 查了下MSDN,记录如下：

	public bool SelectNextControl (
 		Control ctl,
 		bool forward,
 		bool tabStopOnly,
 		bool nested,
 		bool wrap
	)
参数
ctl
从其上开始搜索的 Control。 

forward
如果为 true 则在 Tab 键顺序中前移；如果为 false 则在 Tab 键顺序中后移。 

tabStopOnly
true 表示忽略 TabStop 属性设置为 false 的控件；false 表示不忽略。 

nested
true 表示包括嵌套子控件（子控件的子级）；false 表示不包括。 

wrap
true 表示在到达最后一个控件之后从 Tab 键顺序中第一个控件开始继续搜索；false 表示不继续搜索。 


返回值
如果控件已激活，则为 true；否则为 false。 
备注
如果在 ControlStyles 中将控件的 Selectable 样式位设置为 true，且该控件包含在另一个控件中，并且其所有父控件都可见并已启用，则 

SelectNextControl 方法将激活 Tab 键顺序中的下一个控件。

下面列表中的 Windows 窗体控件是不可选择的。从该列表中的控件派生的控件也是不可选择的。

Label Panel GroupBox PictureBox ProgressBar Splitter LinkLabel（当控件中没有链接时）

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/18/1605280.html "原文首发")