---
layout: post
title: "通过代码生成机制实现强类型编程-CodeSimth版"
description: "通过代码生成机制实现强类型编程-CodeSimth版"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 一直想写一个Code生成系列，但写到CodeSimth，发觉在[TerryLee](http://terrylee.cnblogs.com/archive/2005/12/28/306254.aspx) 和[努力学习的小熊](http://www.cnblogs.com/Bear-Study-Hard/category/43725.html) 两位大牛的博客里讲很详尽，所以就像写些示例方面的，但是苦于没有想到写些什么。最近[Artech](http://www.cnblogs.com/artech/)写了两篇[从数据到代码&#8212;&#8212;通过代码生成机制实现强类型编程--上篇和下篇](http://www.cnblogs.com/artech/archive/2010/09/16/1827499.html)，大牛写得是CodeDom的，今天我就想借借大牛的示例写个CodeSimth版的，希望[Artech](http://www.cnblogs.com/artech/)不要怪我，呵呵。我的Code生成技术已经写了CodeDom的见[CodeDom系列目录](http://www.cnblogs.com/whitewolf/archive/2010/07/09/1774279.html)，欢迎各位园友指教。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 好直接到主题。首先是数据实体MessageEntry（我到老A的基础上添加了description属性作为代码字段描述）：

           public class MessageEntry 
            { 
                public string Id { get; private set; } 
                public string Value { get; private set; }        
                public string Description { get; private set; } 
                public MessageEntry(string id, string value) 
                { 
                    this.Id = id; 
                    this.Value = value;         
                } 

                public MessageEntry(string id, string value, string description) 
                { 
                    this.Id = id; 
                    this.Value = value; 
                    this.Description = description; 
                } 

                public string Format(params object[] args) 
                { 
                    return string.Format(this.Value, args); 
                } 
            } 

在我的机子上的CodeSimth是2..0版本的所以不能使用Linq命名空间，我又想利用这个空间，比较快捷，所以我就在先3.0转化为

Dictionary&lt;string, List&lt;MessageEntry&gt;&gt;实体再传入模板：

Code：

         using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 
        using System.Xml; 
        using System.Xml.Linq; 

        namespace Wolf 
        { 
            public class MessageCodeGenerator 
            { 
                public Dictionary<string, List<MessageEntry>> GeneratorCode(string  path) 
                { 
                    return GeneratorCode(XElement.Load(path)); 
                } 
                public Dictionary<string, List<MessageEntry>> GeneratorCode(XElement root) 
                { 

                    var elemts = root.Elements("message").GroupBy(e => ((XAttribute)e.Attribute("category")).Value); 
                    Dictionary<string, List<MessageEntry>> 	dict = new Dictionary<string, List<MessageEntry>>(); 
                    foreach (var item in elemts) 
                    { 
                        List<MessageEntry> list = new List<MessageEntry>(); 
                        foreach (var g in item) 
                        { 
                            if (g.Attribute("description") != null) 
                            { 
                                list.Add(new MessageEntry(((XAttribute)g.Attribute("id")).Value, ((XAttribute)g.Attribute("value")).Value, ((XAttribute)g.Attribute("description")).Value)); 
                            } 
                            else 
                            { 
                                list.Add(new MessageEntry(((XAttribute)g.Attribute("id")).Value, ((XAttribute)g.Attribute("value")).Value)); 
                            } 

                        } 
                        dict.Add(item.Key.ToString(), list); 
                    } 
                    return dict; 

                } 
            } 
        }
 
 这下就可以开始写模板了，见下Code：

          <%@ CodeTemplate Language="C#" TargetLanguage="Text" Src="" Inherits="" Debug="False" Description="Template description here." %> 

        <%@ Import NameSpace="System" %> 
        <%@ Import NameSpace="System.Xml" %> 
        <%@ Import NameSpace="System.Text" %> 
        <%@ Import NameSpace="System.Collections.Generic" %> 
        <%@ Import NameSpace="Wolf" %> 
        <%@ Assembly Name="Wolf" %> 

        <script runat="template"> 

        private Dictionary<string, List<MessageEntry>> dict; 
        public Dictionary<string, List<MessageEntry>> Generator 
        { 
            get 
            { 
                return dict; 
            } 
            set 
            { 
                dict=value; 
            } 
        } 

        public string GeneratorCode() 
                {            
                    string str = "using Wolf;\r\nusing System;\r\nusing System.Collections.Generic;\r\nnamespace Wolf.Message\r\n{ \r\n   public class Messages\r\n    {\r\n"; 
                    foreach (string catage in Generator.Keys) 
                    { 
                        str += "        public class  "+catage + "\r\n        {        \r\n"; 
                        foreach (Wolf.MessageEntry entry in Generator[catage]) 
                        { 
                            str += "\r\n            /// <summary>" + 
                            "\r\n            ///" + entry.Description + 
                            "\r\n            /// </summary>" + 
                            "\r\n            public static Wolf.MessageEntry " + entry.Id + " = new MessageEntry(\"" + entry.Id + "\", \"" + entry.Value +"\", \"" + entry.Value +"\");\r\n"; 
                        } 
                        str += "\r\n        }\r\n\r\n"; 

                    } 
                    str += "\r\n    }\r\n}"; 
                    return str; 
                } 

        </script> 
        //Copyright (C) Wolf.  All rights reserved. 
        <%=  GeneratorCode()%>
很简单，就不说了，如果有问题请留言，其中命名空间完全可以以属性方式传入。

XMl实体用的是老A的：

     <?xml version="1.0" encoding="utf-8" ?>  
        <messages>   
        <message id="MandatoryField" value="The {0} is mandatory."  category="Validation"  description="description" />   
        <message id="GreaterThan" value="The {0} must be greater than {1}."  category="Validation" description="description" />   
        <message id="ReallyDelete" value="Do you really want to delete the {0}."  category="Confirmation" description="description" />  
    </messages>

我想脱离CodeSimth工具，所以在建立了一个控制台程序，引用CodeSmith.Engine.dll程序集。

Code：

  	 public static void Main(string[] args) 
           { 
              // 	Wolf.Message.Messages.Confirmation.ReallyDelete.Value 
               // test(); 
               CodeTemplate template = CompileTemplate(@"E:\MyApp\LinqTest\ConsoleApplication1\MessageCodeGenerator.cst",s=>Console.WriteLine(s)); 
               if (template != null) 
               { 
                   template.SetProperty("_MessageFilePath", ""); 
                   Wolf.MessageCodeGenerator gen = new MessageCodeGenerator(); 
          Dictionary<string, List<MessageEntry>> dict = gen.GeneratorCode(@"E:\MyApp\LinqTest\ConsoleApplication1\Sample.xml"); 
                   template.SetProperty("Generator", dict); 
                   template.RenderToFile("gen.cs", true); 
                  // System.Diagnostics.Process.Start("gen.cs"); 
               } 
              // Console.Read(); 

           }

           public static CodeTemplate CompileTemplate(string templateName,Action<string> errorWriter) 
           { 
               CodeTemplateCompiler compiler = new CodeTemplateCompiler(templateName); 
               compiler.Compile(); 

               if (compiler.Errors.Count == 0) 
               { 
                   return compiler.CreateInstance(); 
               } 
               else 
               { 
                   for (int i = 0; i < compiler.Errors.Count; i++) 
                   { 
                       errorWriter(compiler.Errors[i].ToString()); 
                   } 
                   return null; 
               } 

           }

生成后的代码：

&nbsp;

     using Wolf; 
    using System; 
    using System.Collections.Generic; 
    namespace Wolf.Message 
    { 
        public class Messages 
        { 
            public class Validation 
            { 

                /// <summary> 
                ///description 
                /// </summary> 
                public static Wolf.MessageEntry MandatoryField = new MessageEntry("MandatoryField", 

    "The {0} is mandatory.", "The {0} is mandatory."); 

                /// <summary> 
                ///description 
                /// </summary> 
                public static Wolf.MessageEntry GreaterThan = new MessageEntry("GreaterThan", 

    "The {0} must be greater than {1}.", "The {0} must be greater than {1}."); 

            } 

            public class Confirmation 
            { 

                /// <summary> 
                ///description 
                /// </summary> 
                public static Wolf.MessageEntry ReallyDelete = new MessageEntry("ReallyDelete", 

    "Do you really want to delete the {0}.", "Do you really want to delete the {0}."); 

            } 

        } 
    }

ok，全部完成。同时你也可以完全集成与VS中利用VSX Vs扩展，可以参考[明年我18 的VSX系列](http://www.cnblogs.com/default/archive/2010/02/26/1674582.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/09/25/CodeSimthNamedCMessage.html "原文首发")