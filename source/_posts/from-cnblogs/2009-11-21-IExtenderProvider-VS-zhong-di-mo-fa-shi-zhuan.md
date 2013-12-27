---
layout: post
title: "IExtenderProvider - VS中的魔法师 [转]"
description: "IExtenderProvider - VS中的魔法师 [转]"
category: cnblogs
tags: [code,cnblogs]
---
**前言**

<div class="postbody">

在需要录入数据的字段比较多的表单应用程序中，为了给用户更好的体验，我们通常会将[Enter]键转为[TAB]将输入焦点移到下一个控件，或是将获得焦点的输入控件背景经一个醒目的背景颜色显示等等。以往的做法通常是从TextBox、ComboBox等标准输入控件派生一个新的控件，在新控件中改变击键和在获得/失去焦点时的动作，但此方法的不便之外就是到项目的最后，会增加了一系列的标准控件的小功能扩展控件，增大了后期的维护工作量。在DotNet中，对于类似的对标准控件的&#8220;小功能扩展&#8221;我们有了更好解决方案，那就是神奇的IExtenderProvider接口，它可以给任何控件&#8220;变&#8221;出一个属性来^_^

#### **关于IExtenderProvider&nbsp;接口**

IExtenderProvider位于System.ComponentModel命名空间，其声明如下：

&nbsp;

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:4c9e8390-f491-48d8-8426-2ec247b1fbbf" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">interface</span><span style="color: #000000"> IExtenderProvider
{
</span><span style="color: #0000ff">bool</span><span style="color: #000000"> CanExtend(</span><span style="color: #0000ff">object</span><span style="color: #000000"> extendee);
}
</span></div>
</pre></div>

&nbsp;

此接口只有一个方法`bool CanExtend(object)`，这个方法告诉VS.net设计器是否将扩展属性显示在给出控件的属性窗口中。实现了IExtenderProvider接口的组件称为&#8220;扩展程序提供程序&#8221;。DotNet 2.0中自带的ToolTips和ErrorProvider就是二个典型的扩展程序提供程序。如将ToolTips控件添加到窗体中后，TextBox1控件便多了个ToolTips on toolTips1的属性。

&nbsp;![](http://images.cnblogs.com/cnblogs_com/wuchang/200701/01.png)

我们在属性窗口中给此属性设置值时，VS.net设计器生成如下的代码：

&nbsp;

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:0e1f80db-37d8-4ddd-ad48-19f0fe87b0c4" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #0000ff">this</span><span style="color: #000000">.toolTip1.SetToolTip(</span><span style="color: #0000ff">this</span><span style="color: #000000">.textBox1, </span><span style="color: #000000">"</span><span style="color: #000000">some tooltips</span><span style="color: #000000">"</span><span style="color: #000000">);</span></div>
</pre></div>
可见，我们给ToolTips on toolTips1属性设置的文本是存储在toolTips1控件中，但是程序执行时是在textBox1上显示相应的提示信息而不是在toolTips1上。这样，我们无需对窗体上现有的控件做任何修改就可以让他们都有了toolTips提示功能! 

&nbsp;

接下来，我们来创建一个自己的扩展程序提供程序，给TextBox控件添加[ConverEnterToTAB]功能。

**创建自己的IExtenderProvider&nbsp;组件**

这时候我们注意到`IExtenderProvider接口`并没有提供任何有关扩展属性的消息，那vs.net设计器是如何知道扩展程序提供什么样的扩展属性给控件呢？是`ProvideProperty特性(Attribute)!设计器会在实现<code>IExtenderProvider`接口的组件中寻找所有的`ProvideProperty`特性，`ProvideProperty`特性标明了扩展程序给什么类型的控件提供什么扩展扩展属性的信息。`ProvideProperty特性的声明如下：
`</code>

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; width: 560px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:44eb2a50-3928-4807-80d0-29c1972446a0" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #000000">[AttributeUsageAttribute(AttributeTargets.Class, AllowMultiple</span><span style="color: #000000">=</span><span style="color: #0000ff">true</span><span style="color: #000000">)]
</span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">sealed</span><span style="color: #000000"> </span><span style="color: #0000ff">class</span><span style="color: #000000"> ProvidePropertyAttribute : Attribute
</span></div>
</pre></div>
此特性有二个构造方法：

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:9a867422-aad3-4771-be4d-e688aee09a71" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #0000ff">public</span><span style="color: #000000"> ProvidePropertyAttribute (
</span><span style="color: #0000ff">string</span><span style="color: #000000"> propertyName,   </span><span style="color: #008000">//</span><span style="color: #008000">扩展到指定类型对象的属性名称。</span><span style="color: #008000">
</span><span style="color: #000000">    </span><span style="color: #0000ff">string</span><span style="color: #000000"> receiverTypeName   </span><span style="color: #008000">//</span><span style="color: #008000">此属性可以扩展的数据类型的名称。 </span><span style="color: #008000">
</span><span style="color: #000000">)
</span><span style="color: #000000">--------------------------------------------</span><span style="color: #000000">
</span><span style="color: #0000ff">public</span><span style="color: #000000"> ProvidePropertyAttribute (
</span><span style="color: #0000ff">string</span><span style="color: #000000"> propertyName,   </span><span style="color: #008000">//</span><span style="color: #008000">扩展到指定类型对象的属性名称。 </span><span style="color: #008000">
</span><span style="color: #000000">    Type receiverType   </span><span style="color: #008000">//</span><span style="color: #008000">可以接收此属性的对象的数据类型的 Type。</span><span style="color: #008000">
</span><span style="color: #000000">)</span></div>
</pre></div>
`在ProvideProperty特性中指定提供的属性的名称和可接收属性的组件类型，如，下面代码给TextBox类型组件添加一个名为&lt;Name&gt;的属性：` 

&nbsp;

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:cba84224-723a-4d26-a2e6-b0a81fb97525" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #000000">[ProvideProperty(</span><span style="color: #000000">"</span><span style="color: #000000">&lt;Name&gt;</span><span style="color: #000000">"</span><span style="color: #000000">, </span><span style="color: #0000ff">typeof</span><span style="color: #000000">(TextBox))]
</span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">class</span><span style="color: #000000"> TextboxExtender : Component, IExtenderProvider
{...</span></div>
</pre></div>

一旦在控件上声明了ProvideProperty特性，就需要在控件中提供名为Get&lt;Name&gt;和Set&lt;Name&gt;的二个Public方法。Get&lt;Name&gt;方法有一个参数，参数类型和ProvideProperty特性中定义的类型相同，返回此组件此属性的值。Set&lt;Name&gt;方法带两个参数，第一个参数是`ProvideProperty特性中指定的组件类型，第二个参数是要设置给扩展属性的数据，类型和Get&lt;Name&gt;方法返回的数据类型相同。`

下列是给TextBox添加EnableConvertEnterToTab扩展属性的完整代码：

<div style="padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; display: inline; float: none; padding-top: 0px" id="57F11A72-B0E5-49c7-9094-E3A15BD5B5E7:7e419b41-f1e2-49ce-9319-71be8d637011" class="wlWriterSmartContent" contenteditable="false"><pre style="background-color: white"><div><!-- Code highlighting produced by Actipro CodeHighlighter (freeware)
http://www.CodeHighlighter.com/
--><span style="color: #0000ff">namespace</span><span style="color: #000000"> wuChang.Controls
{
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> 将TextBox的回车键转换为TAB键
</span><span style="color: #808080">///</span><span style="color: #008000"> wuChang@guet.edu.cn
</span><span style="color: #808080">///</span><span style="color: #008000"> wuchang.cnblogs.com
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;/summary&gt;</span><span style="color: #808080">
</span><span style="color: #000000">    [ProvideProperty(</span><span style="color: #000000">"</span><span style="color: #000000">EnableConvertEnterToTab</span><span style="color: #000000">"</span><span style="color: #000000">, </span><span style="color: #0000ff">typeof</span><span style="color: #000000">(TextBox))]
</span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">class</span><span style="color: #000000"> TextboxExtender : Component, IExtenderProvider
{
</span><span style="color: #0000ff">private</span><span style="color: #000000"> Hashtable htDate </span><span style="color: #000000">=</span><span style="color: #000000"> </span><span style="color: #0000ff">new</span><span style="color: #000000"> Hashtable();
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> 取得相应组件EnableConvertEnterToTab扩展属性的值
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;/summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;param name="control"&gt;&lt;/param&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;returns&gt;&lt;/returns&gt;</span><span style="color: #808080">
</span><span style="color: #000000">        [DefaultValue(</span><span style="color: #0000ff">false</span><span style="color: #000000">)]
[Description(</span><span style="color: #000000">"</span><span style="color: #000000">是否允许将回车键转换为TAB键</span><span style="color: #000000">"</span><span style="color: #000000">)]
</span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">bool</span><span style="color: #000000"> GetEnableConvertEnterToTab(TextBox control)
{
</span><span style="color: #0000ff">return</span><span style="color: #000000"> </span><span style="color: #0000ff">this</span><span style="color: #000000">.htDate.Contains(control);
}
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> 将需要转换Enter的控件保存到Hashtable中，前添加KeyDown事件。
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;/summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;param name="control"&gt;&lt;/param&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;param name="value"&gt;&lt;/param&gt;</span><span style="color: #808080">
</span><span style="color: #000000">        </span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">void</span><span style="color: #000000"> SetEnableConvertEnterToTab(TextBox control, </span><span style="color: #0000ff">bool</span><span style="color: #000000"> value)
{
</span><span style="color: #0000ff">if</span><span style="color: #000000"> (value)
{
</span><span style="color: #0000ff">this</span><span style="color: #000000">.htDate.Add(control, value);
control.KeyDown </span><span style="color: #000000">+=</span><span style="color: #000000"> </span><span style="color: #0000ff">new</span><span style="color: #000000"> KeyEventHandler(control_KeyDown);
}
</span><span style="color: #0000ff">else</span><span style="color: #000000">
{
control.KeyDown </span><span style="color: #000000">-=</span><span style="color: #000000"> </span><span style="color: #0000ff">new</span><span style="color: #000000"> KeyEventHandler(control_KeyDown);
</span><span style="color: #0000ff">this</span><span style="color: #000000">.htDate.Remove(control);
}
}
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> 将目标控件的键盘事件{Enter}转为{TAB}
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;/summary&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;param name="sender"&gt;&lt;/param&gt;</span><span style="color: #008000">
</span><span style="color: #808080">///</span><span style="color: #008000"> </span><span style="color: #808080">&lt;param name="e"&gt;&lt;/param&gt;</span><span style="color: #808080">
</span><span style="color: #000000">        </span><span style="color: #0000ff">void</span><span style="color: #000000"> control_KeyDown(</span><span style="color: #0000ff">object</span><span style="color: #000000"> sender, KeyEventArgs e)
{
</span><span style="color: #0000ff">if</span><span style="color: #000000"> (e.KeyCode </span><span style="color: #000000">==</span><span style="color: #000000"> Keys.Enter)
{
e.Handled </span><span style="color: #000000">=</span><span style="color: #000000"> </span><span style="color: #0000ff">true</span><span style="color: #000000">;
SendKeys.Send(</span><span style="color: #000000">"</span><span style="color: #000000">{TAB}</span><span style="color: #000000">"</span><span style="color: #000000">);
}
}
</span><span style="color: #0000ff">#region</span><span style="color: #000000"> IExtenderProvider Members</span><span style="color: #000000">
</span><span style="color: #0000ff">public</span><span style="color: #000000"> </span><span style="color: #0000ff">bool</span><span style="color: #000000"> CanExtend(</span><span style="color: #0000ff">object</span><span style="color: #000000"> extendee)
{
</span><span style="color: #0000ff">return</span><span style="color: #000000"> extendee </span><span style="color: #0000ff">is</span><span style="color: #000000"> TextBox;
}
</span><span style="color: #0000ff">#endregion</span><span style="color: #000000">
}
}</span></div>
</pre></div>

注意这里给给GetEnableConvertEnterToTab方法添加[DefaultValue(false)]特性，这样如果给组件的GetEnableConvertEnterToTab扩展属性设计值为False时，设计器将不会生成设置代码。如设置扩展属性为true时会生成这样的代码：
this.textboxExtender1.SetEnableConvertEnterToTab(this.textBox1, true);
设置为Falsh时，设计器不会生成任何的代码。
</div>

![img](http://images.cnblogs.com/cnblogs_com/wuchang/200701/02.png)


参考资料：

1. [http://www.codeproject.com/dotnet/iextenderprovider.asp](http://www.codeproject.com/dotnet/iextenderprovider.asp "http://www.codeproject.com/dotnet/iextenderprovider.asp")
2. [ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_fxdeveloping/html/21e34929-ff78-4f3f-aee8-a16a4ef5ac9d.htm](http://www.cnblogs.com/whitewolf/admin/ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_fxdeveloping/html/21e34929-ff78-4f3f-aee8-a16a4ef5ac9d.htm "ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_fxdeveloping/html/21e34929-ff78-4f3f-aee8-a16a4ef5ac9d.htm")

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/21/1607678.html "原文首发")