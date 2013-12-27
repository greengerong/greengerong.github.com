---
layout: post
title: "MEF学习笔记"
description: "MEF学习笔记"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp; MEF是 Managed Extensibility Framework简称，在计算机的世界什么都会加一个简称，这我们大家已经司空见惯了。从名字我们可以知道它是一个用于管理的可扩展性框架。这是和EL不同的另一种IOC方式;

&nbsp;&nbsp; MEF 为我们提供了一种运行时的扩展，具体应用在对象的实例化。它有目录（AssemblyCatalog）和容器（CompositionContainer）组成，他有输入输出（Exports和Imports）元数据标记，在对象实例化的时候会自动匹配这个契约。

下面是官方的一个展示图：

[![untitled](http://images.cnblogs.com/cnblogs_com/whitewolf/Windows-Live-Writer/0291ec4c7408_12966/untitled_thumb.png "untitled")](http://images.cnblogs.com/cnblogs_com/whitewolf/Windows-Live-Writer/0291ec4c7408_12966/untitled.png)

由CompositionContainer来管理我们的多个可组合部件。

下面我们来一个简单的示例来初步了解MEF:

控制台程序：

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/-->using System; 
        using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 
        using System.ComponentModel.Composition;//添加引用 
          


        namespace MEFTest 
        { 
            public interface ILog 
            { 
                void Write(string message); 
            } 
            
            [System.ComponentModel.Composition.Export(typeof(ILog))] 
            public class ConsoleLog:ILog 
            { 
                public void Write(string message) 
                { 
                    Console.WriteLine("Hello:"+message); 
                } 
            } 
            class Program 
            { 
                [System.ComponentModel.Composition.Import(typeof(ILog))] 
                public ILog Log; 
                static void Main(string[] args) 
                { 
                    Program pro = new Program(); 
                    pro.Init(); 
                    pro.Log.Write("Test"); 
                    Console.Read(); 
                }

                public void Init() 
                { 
                    var assem = System.Reflection.Assembly.GetExecutingAssembly();//当前程序集 
                    var assemcat = new System.ComponentModel.Composition.Hosting.AssemblyCatalog(assem);//构建目录 
                    var container = new System.ComponentModel.Composition.Hosting.CompositionContainer(assemcat);//构建容器 
                    container.ComposeParts(this);//这是一个System.ComponentModel.Composition.AttributedModelServices 的扩展方法。 
                } 
            } 
        }

输出为：

Hello:Test 

ExportAttribute 定义如下： 

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/-->[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method | AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = true, Inherited = false)] 
        public class ExportAttribute : Attribute 
        { 
            
            [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
           
            [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
           
            [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
            public ExportAttribute(Type contractType); 
           
            public ExportAttribute(string contractName, Type contractType);

            
            public string ContractName { get; } 
            
            public Type ContractType { get; } 
        }
        
从他的定义我们可以知道他可以运用于我们的类、方法、属性、字段，并且可以多继承，但是不存在从父类的继承特性。

他有三种不同的标记方式方式.在MEF中这里标记为可以导出，即注入到Import。

ImportAttribute 定义：

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/-->[AttributeUsage(AttributeTargets.Property | AttributeTargets.Field | AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)] 
            public class ImportAttribute : Attribute, IAttributedImport 
            { 
               
                [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
                public ImportAttribute(); 
               
                [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
                public ImportAttribute(string contractName); 
               
                [TargetedPatchingOptOut("Performance critical to inline this type of method across NGen image boundaries")] 
                public ImportAttribute(Type contractType); 
               
                public ImportAttribute(string contractName, Type contractType); 
               
                public bool AllowDefault { get; set; }

                public bool AllowRecomposition { get; set; } 
                
                public string ContractName { get; } 
                
                public Type ContractType { get; } 
                
                public CreationPolicy RequiredCreationPolicy { get; set; } 
            }

&nbsp;同上Export,这里标记为可被Export注入的接口点。

今天就写到这里了，希望大家多多指教，大家一起共同进步。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/11/11/MEF1.html "原文首发")