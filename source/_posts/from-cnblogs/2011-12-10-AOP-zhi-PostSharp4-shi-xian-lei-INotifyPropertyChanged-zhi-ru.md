---
layout: post
title: "AOP之PostSharp4-实现类INotifyPropertyChanged植入"
description: "AOP之PostSharp4-实现类INotifyPropertyChanged植入"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在前面几篇PostSharp的随笔，今天来一个简单的demo。PostSharp的其他内容将会在后面继续更新。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如果我们了解wpf或者silverlight开发中的MVVM模式，就知道框架要求我们的ViewModel必须实现INotifyPropertyChanged，来得到属性改变的事件通知，更新UI。

实现INotifyPropertyChanged接口很简单，而且一沉不变，属于重复劳动。在这里我们将看看如何运用PostSharp来解决我们的重复劳动。当然这里只是一个demo演示，具体在项目开发中你直接实现INotifyPropertyChanged，或者AOP植入，这取决我个人和团队文化。

&nbsp;&nbsp;&nbsp;&nbsp; 在下面我们将会用到Postsharp的：

1.  IntroduceMember：向目标对象植入成员。
2.  IntroduceInterface：使得目标实现接口，参数接口类型。
3.  OnLocationSetValueAdvice：PostSharp的一种Advice Aspect。

&nbsp;&nbsp; 下面我就看看我们的代码是如何简洁来实现：

     using System;
      using System.ComponentModel;
      using PostSharp.Aspects;
      using PostSharp.Aspects.Advices;
      using PostSharp.Extensibility;

      namespace PostSharpDemo
      {
          [Serializable]
          [IntroduceInterface(typeof(INotifyPropertyChanged), OverrideAction = InterfaceOverrideAction.Ignore)]
          public class INotifyPropertyChangedAttribute : InstanceLevelAspect, INotifyPropertyChanged
          {

              [OnLocationSetValueAdvice, MulticastPointcut(Targets = MulticastTargets.Property)]
              public void OnValueChanged(LocationInterceptionArgs args)
              {
                  var current=args.GetCurrentValue();
                  if ((args.Value != null && (!args.Value.Equals(current)))
                      || (current != null && (!current.Equals(args.Value))))
                  {
                      args.ProceedSetValue();
                      this.OnRaisePropertyChange(args.Location.Name);
                  }
              }

              #region INotifyPropertyChanged 成员

              [IntroduceMember(IsVirtual = true, OverrideAction = MemberOverrideAction.Ignore)]
              public event PropertyChangedEventHandler PropertyChanged;




              protected void OnRaisePropertyChange(string property)
              {
                  if (PropertyChanged != null)
                  {
                      PropertyChanged.Invoke(this.Instance, new PropertyChangedEventArgs(property));
                  }
              }
              #endregion
          }
      }
      

测试代码：

static void Main(string[] args) 
        { 

             Student stu = new Student(); 
            (stu as INotifyPropertyChanged).PropertyChanged += new PropertyChangedEventHandler(Program_PropertyChanged); 
            stu.ID = 10; 
            stu.Name = "wolf"; 
            stu.Sex = "Man"; 
            stu.ID = 2; 
            Console.Read(); 
        } 

        static void Program_PropertyChanged(object sender, PropertyChangedEventArgs e) 
        { 
            Console.WriteLine(string.Format("property {0} has changed", e.PropertyName)); 
        }

实体类：

      [INotifyPropertyChanged] 
       public class Student 
       { 
           public string Name 
           { get; set; } 

           public string Sex 
           { get; set; } 

           public int ID 
           { get; set; } 
       }
<div class="cnblogs_code">运行效果如下：</div>

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112102006218755.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112102006066024.png) 

附件下载：[demo](http://files.cnblogs.com/whitewolf/PostSharpDemo.rar)

本博客中相关文章有：

1. [<font color="#3d81ee">AOP之PostSharp初见-OnExceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
2. [<font color="#3d81ee">AOP之PostSharp2-OnMethodBoundaryAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
3. [<font color="#3d81ee">AOP之PostSharp3-MethodInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
4. [<font color="#6699cc">AOP之PostSharp4-实现类INotifyPropertyChanged植入</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
5. [<font color="#6699cc">AOP之PostSharp5-LocationInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
6.  [<font color="#6699cc">AOP之PostSharp6-EventInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
7.   [<font color="#3d81ee">http://www.cnblogs.com/whitewolf/category/312638.html</font>](http://www.cnblogs.com/whitewolf/category/312638.html) 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html "原文首发")