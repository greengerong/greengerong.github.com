---
layout: post
title: "Razor Templating Engine"
description: "Razor Templating Engine"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 最近遇到html模板解析，我完全可以用MS的T4模板或者是StringTemplate等其他的模板来做，但是出于尝试和对Razor语发的感兴趣，便翻了翻Razor模板的资料，其CodePlex主页[http://razorengine.codeplex.com/](http://razorengine.codeplex.com/ "http://razorengine.codeplex.com/")。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 下面讲的都是一些其主页上面的例子，所以请大家别拍砖。别后面想到有些实际意义的例子在写个具体的运用例子吧。

         public static class Razor 
        { 
            public static string Parse(string template, string name = null); 
            public static string Parse<T>(string template, T model, string name = null); 
            public static void SetLanguageProvider(ILanguageProvider provider); 
            public static void SetMarkupParser(MarkupParser parser); 
            public static void SetTemplateBaseType(Type type); 
        }
        
在Razor这个静态类中最重要的方法当然是我们的Parse方法了，其有两个重载，在第二个重载在我们可以传入Template的Model，了解asp.net mvc都会知道这个Model。同时我们可以用SetLanguageProvider方法传入LanguageProvider（C#、VB）等，SetTemplateBaseType传入模板BaseType（可能是我们的自定义类型）。

1：先来个简单的Template：

 	static void Main(string[] args) 
               { 
                   string template = "Hello @Model.Name! Welcome to Razor!"; 
                   string result = Razor.Parse(template, new { Name = "World" });         
                   Console.WriteLine(result); 
                   Console.Read(); 
               }
               
       
输出结果：

Hello World! Welcome to Razor!

在这里我们传入的是new { Name = "World" }的匿名对象的Model。

2：内部嵌套方法：

 
 	string template = @"@helper MyMethod(string name) {

		Hello @name

	}

	@MyMethod(Model.Name)! Welcome to Razor!"; 

	string result = Razor.Parse(template, new { Name = "World" });

 输出同样是上边的结果，但是注意这里的与上面不同的是在{}中间的空格等是不会忽略的。我的理解是同样是一个模板的形式吧。

3：传递模板参数：

在传递参数的情况下我们可以采用自定义类，继承至TemplateBase 或者TemplateBase&lt;T&gt;，后者是带Model的情形。

还是官方的例子来看看，

         

    static void Main(string[] args) 
        { 
            Razor.SetTemplateBaseType(typeof(MyCustomTemplateBase<>));

            string template = "My name in UPPER CASE is: @ToUpperCase(Model.Name)"; 
            string result = Razor.Parse(template, new { Name = "Matt" });

            Console.WriteLine(result); 
            Console.Read(); 
        } 
    } 
    public abstract class MyCustomTemplateBase<T> : TemplateBase<T> 
    { 
        public string ToUpperCase(string name) 
        { 
            return name.ToUpper(); 
        } 
    }
    
输出结果为：My name in UPPER CASE is: MATT。

在我们的MyCustomTemplateBase&lt;T&gt;抽象类中我们可以像MVC一样定义一些辅助属性和方法，像html、Request、Response等辅助类等 

有事我们需要自定义一些非modle的非static property给Template，我的考虑是在TemplateService 中的重写Parse方法中初始化Action：
public string Parse&lt;T&gt;(string template, T model, string name = null，Action&lt;ITemplate&lt;dynamic&gt;&gt; initAction);

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/12/22/1913718.html "原文首发")