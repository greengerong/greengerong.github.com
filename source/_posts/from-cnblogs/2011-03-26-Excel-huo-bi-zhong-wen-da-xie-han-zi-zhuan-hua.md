---
layout: post
title: "Excel 货币中文大写汉字转化"
description: "Excel 货币中文大写汉字转化"
category: cnblogs
tags: [code,cnblogs]
---
Excel转化货币数字为中文大写：例如：

效果图：

![](http://images.cnblogs.com/cnblogs_com/whitewolf/ExcelP.jpg)

代码：

     =IF(D8<1,IF(D8<0.1,TEXT(INT(D8*100),"[DBNum2]G/通用格式")&"分",IF((INT(D8*100)-INT(D8*10)*10=0),TEXT(INT(D8*10),"[DBNum2]G/通用格式")&"角整",TEXT(INT(D8*10),"[DBNum2]G/通用格式")&"角"&TEXT(INT(D8*100)-INT(D8*10)*10,"[DBNum2]G/通用格式")&"分")),TEXT(INT(D8),"[DBNum2]G/通用格式"&"元")&IF((INT(D8*10)-INT(D8)*10)=0,IF((INT(D8*100)-INT(D8*10)*10)=0,"","零"),IF((INT(D8*0.1)-INT(D8)*0.1)=0,"零","")&TEXT(INT(D8*10)-INT(D8)*10,"[DBNum2]G/通用格式")&"角")&IF((INT(D8*100)-INT(D8*10)*10)=0,"整",TEXT(INT(D8*100)-INT(D8*10)*10,"[DBNum2]G/通用格式")&"分"))

&nbsp;这个奖可以结合ASPOSE.Cells处理我的报表导出Excel的汇总，计算问题：[<font color="#6699cc">报表中的Excel操作之Aspose.Cells（Excel模板）</font>](http://www.cnblogs.com/whitewolf/archive/2011/03/21/Aspose_Cells_Template1.html) 唯一需要改变的就是D8这个单元汇总格是需要动态变更的，可以利用{r}。{-n}，{c}等来处理。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/03/26/1996192.html "原文首发")