---
layout: post
title: "AOP之PostSharp5-LocationInterceptionAspect"
description: "AOP之PostSharp5-LocationInterceptionAspect"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; 这节我们要讨论的是PostSharp的LocationInterceptionAspect，PostSharp官方把Property和Field成为Location。所以LocationInterceptionAspect就是为了实现Property和Field的拦截。在我们前面讨论了关于方法OnMethodBoundaryAspect的aspect，我们很容易想到，在c#中Property就是一个编译时分为Get和Set两个方法，对于property的aspect就类似于了我们的Method的aspect。而对于Field的aspect同样可以转换为对Property的aspect。

下面我们用反编译工具来证实一下我的说法.

代码：

	    [LazyLoad("test", "test")] 
         private string TestField;

编译后：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445152198.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/20111211144511133.png) 

我们在来看看LocationInterceptionAspect定义：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445215649.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445172495.png) 

其OnGetvalue和OnSetValue是我们主要拦截的方法，起参数LocationInterceptionArgs定义：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445362807.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445276277.png) 

同样给也拥有来自父类AdviceArgs的Instance对象，对于对象级Location为所在对象，静态则为null；

LocationInterceptionAspect的使用方法和我们的OnMethodBoundaryAspect和类似，使用方式也一样，对于使用对不重要，鄙人觉得更重要的是我们的设计思想。

我暂时能想到的很好的LocationInterceptionAspect使用场景则是LazyLoad，对于3.5表达式的出现，我们到处都可以简单这个词，在c#类库中也加入了这个类。

这里我们只是做一个简单的演示demo，根据attribute上制定的类型的方法延时加载对象，废话不说了上code：


  [Serializable] 
       public class LazyLoadAttribute : LocationInterceptionAspect 
       { 
           public string MethodName 
           { 
               get; 
               private set; 
           } 

           public string PrivoderFullName 
           { 
               get; 
               private set; 
           } 

           public LazyLoadAttribute(string MethodName, string PrivoderFullName) 
           { 
               Green.Utility.Guard.ArgumentNotNullOrEmpty(MethodName, "MethodName"); 
               Green.Utility.Guard.ArgumentNotNullOrEmpty(PrivoderFullName, "PrivoderFullName"); 
               this.MethodName = MethodName; 
               this.PrivoderFullName = PrivoderFullName; 
           } 

           public override void OnGetValue(LocationInterceptionArgs args) 
           { 
               if (args.GetCurrentValue() == null) 
               { 
                   Console.WriteLine("Loading...."); 
                   var value = this.LoadProperty(args.Instance); 
                   if (value != null) 
                   {                    
                       args.Value = value; 
                       args.ProceedSetValue(); 
                   } 
               } 
               args.ProceedGetValue(); 
           } 

           private object LoadProperty(object p) 
           { 
               var type = Type.GetType(this.PrivoderFullName);//具体加载程序集需要自定义需求，这里仅为了测试简化。 
               if (type != null) 
               { 
                   var method = type.GetMethod(this.MethodName); 
                   if (method != null) 
                   { 
                       object[] ps = null; 
                       if (p != null) 
                       { 
                           ps = new object[] { p }; 
                       } 
                       object entity = null; 
                       if (!method.IsStatic) 
                       { 
                           entity = System.Activator.CreateInstance(type); 
                       } 
                       return method.Invoke(entity, ps); 
                   } 
               } 
               return null; 
           } 
       }
       
测试code：

    class Program 
       {       
           static void Main(string[] args) 
           {            

               /* 
                * demo4*/ 

               Student stu = new Student(); 
               stu.ID = 10; 
               Console.WriteLine(stu.Name); 
               Console.WriteLine(stu.Name); 

               Console.WriteLine(Student.TestStaticProperty); 
               Console.WriteLine(Student.TestStaticProperty); 
               Console.Read(); 
           }

    public static string TextLazyLoadStaticMenthod(Student stu) 
          { 
              return "Student" + stu.ID; 
          } 

          public string TextLazyLoadInstacnceMenthod(Student stu) 
          { 
              return "Student" + stu.ID; 
          } 

          public string TextLazyLoadStaticPropertyMenthod() 
          { 
              return "测试"; 
          } 
      }

    public class Student 
       { 
          // [LazyLoad("TextLazyLoadStaticMenthod", "PostSharpDemo.Program,PostSharpDemo")] 
           [LazyLoad("TextLazyLoadInstacnceMenthod", "PostSharpDemo.Program,PostSharpDemo")] 
           public string Name 
           { get; set; } 
           public string Sex 
           { get; set; } 

           [LazyLoad("TextLazyLoadStaticPropertyMenthod", "PostSharpDemo.Program,PostSharpDemo")] 
           public static string TestStaticProperty 
           { get; set; } 

           public int ID 
           { get; set; } 
       }
       
<div class="cnblogs_code" onclick="cnblogs_code_show('c8e815c6-3301-42ff-93ea-f8f84b47d5b3')">效果图片如下：</div>

[![QQ截图未命名](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/201112111445444222.png "QQ截图未命名")](http://images.cnblogs.com/cnblogs_com/whitewolf/201112/20111211144540238.png)

附件下载：[dmeo](http://files.cnblogs.com/whitewolf/PostSharpDemo.rar)

1. [<font color="#3d81ee">AOP之PostSharp初见-OnExceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp1.html)
2. [<font color="#3d81ee">AOP之PostSharp2-OnMethodBoundaryAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp2.html)
3. [<font color="#3d81ee">AOP之PostSharp3-MethodInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/04/PostSharp3.html)
4. [<font color="#6699cc">AOP之PostSharp4-实现类INotifyPropertyChanged植入</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/10/PostSharp4.html)
5. [<font color="#6699cc">AOP之PostSharp5-LocationInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html)
6.  [<font color="#6699cc">AOP之PostSharp6-EventInterceptionAspect</font>](http://www.cnblogs.com/whitewolf/archive/2011/12/13/PostSharp6.html)
7.   [<font color="#3d81ee">http://www.cnblogs.com/whitewolf/category/312638.html</font>](http://www.cnblogs.com/whitewolf/category/312638.html)

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/12/11/PostSharp5.html "原文首发")