---
layout: post
title: "html5-Canvas绘图"
description: "html5-Canvas绘图"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 在html5中我觉得最重要的就是引入了Canvas，使得我们可以在web中绘制各种图形。给人感觉单在这点上有点模糊我们web和桌面程序的感觉。在html5外web中也有基于xml的绘图如：VML、SVG。而Canvas为基于像素的绘图。Canvas是一个相当于画板的html节点，我们必须以js操作绘图。

如下：

&lt;canvas id="myCanvas" width="600" height="300"&gt;你的浏览器还不支持哦&lt;/canvas&gt;定义。

我们可以获取canvas对象为var c=document.getElementById("myCanvas");其应有js属性方法如下列举：

1：绘制渲染对象，c.getContext("2d"),获取2d绘图对象，无论我们调用多少次获取的对象都将是相同的对象。

2：绘制方法：

clecrRect(left,top,width,height)清除制定矩形区域，

fillRect(left,top,width,height)绘制矩形，并以fillStyle填充。

fillText（text,x,y）绘制文字；

strokeRect(left,top,width,height)绘制矩形，以strokeStyle绘制边界。

beginPath():开启路径的绘制,重置path为初始状态；

closePath():绘制路径path结束，它会绘制一个闭合的区间，添加一条起始位置到当前坐标的闭合曲线；

moveTo（x，y）：设置绘图其实坐标。

lineTo(x，y);绘制从当前其实位置到x，y直线。

fill（），stroke（），clip（）：在完成绘制的最后的填充和边界轮廓，剪辑区域。

arc（）：绘制弧,圆心位置、起始弧度、终止弧度来指定圆弧的位置和大小；

rect():矩形路径;

drawImage（Imag img）：绘制图片；

quadraticCurveTo():二次样条曲线路径,参数两个控制点；

bezierCurveTo（）：贝塞尔曲线，参数三个控制点；

createImageData,getImageData，putImageData:为Canvas中像素数据。ImageData为记录width、height、和数据 data，其中data为我们色素的记录为

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; argb，所以数组大小长度为width*height*4，顺序分别为rgba。getImageData为获取矩形区域像素，而putImageData则为设置矩形区域像素；

&#8230; and so on！

3：坐标变换：

translate（x,y）：平移变换，原点移动到坐标（x，y）；

rotate（a）：旋转变换，旋转a度角；

scale（x，y）：伸缩变换；

save（），restore（）：提供和一个堆栈，保存和恢复绘图状态，save将当前绘图状态压入堆栈，restore出栈，恢复绘图状态；

&#8230; and so on！

好了，也晚了。附我的测试代码，：

	<html> 
      <head> 
      </head> 
      <body> 
      <canvas id="myCanvas" width="600" height="300">你的浏览器还不支持哦</canvas> 
      <script type="text/javascript"> 

      var width,height,top,left; 
      width=height=100; 
      top=left=5; 
      var x=10; 
      var y=10; 

      var c=document.getElementById("myCanvas"); 

      var maxwidth=c.width-5; 
      var maxheight=c.height-5; 
      var cxt=c.getContext("2d"); 
      cxt.strokeStyle="#00f"; 
      cxt.strokeRect(0,0,c.width,c.height); 

      var img=new Image(); 
      img.src="1.gif"; 
      var MyInterval=null; 
      start(); 
      function Refresh(){ 
      cxt.clearRect(left,top,width,height); 
      if((left+x)>(maxwidth-width)||left+x<0){ 
      x=-x; 
      } 

      if((top+y)>(maxheight-height)||top+y<0){ 
      y=-y; 
      } 

      left=left+x;    
      top=top+y; 
      cxt.drawImage(img,left,top,width,height); 
      cxt.font="20pt 宋体"; 
      cxt.fillText("破狼",left,top+25); 

      } 

      function start(){ 
      if(MyInterval==null){ 
      MyInterval=setInterval("Refresh()",100); 
      } 
      } 

      function stop(){ 
      if(MyInterval!=null){ 
      clearInterval(MyInterval); 
      MyInterval=null; 
      } 
      } 
      function InRectangle(x,y,rectx,recty,rwidth,rheight){ 
      return (x>=rectx&&x<=rectx+rwidth)&&(y>=recty&&y<=recty+rheight) 
      } 
      c.onmouseover=function(e){ 
      if(InRectangle(e.clientX,e.clientY,left,top,width,height)){ 
      stop(); 
      } 

      c.onmouseout=function(e){ 
      start(); 
      } 

      c.onmousemove=function(e){ 
      if(InRectangle(e.clientX,e.clientY,left,top,width,height)){ 
      if(MyInterval!=null){ 
      stop(); 
      } 
      }else{ 
      start(); 
      } 
      } 

      } 
      </script> 
      </body> 
      </html>

参考火狐html文档：[https://developer.mozilla.org/en/HTML/HTML5](https://developer.mozilla.org/en/HTML/HTML5 "https://developer.mozilla.org/en/HTML/HTML5")

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp; 我的html5系列：

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/03/02/1968512.html "原文首发")