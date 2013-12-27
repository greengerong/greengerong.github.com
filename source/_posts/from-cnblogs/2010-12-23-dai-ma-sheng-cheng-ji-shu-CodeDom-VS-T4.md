---
layout: post
title: "代码生成技术--CodeDom VS T4"
description: "代码生成技术--CodeDom VS T4"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 在微软的自家代码生成方案中我们有两种选择方式:CodeDom 和Text Template Transformation Toolkit（T4）模板。同样我们可以利用简单的String或者StringBuilder来拼接字符串，但是那对于简单的还可以，但是对于复杂的问题就![悲伤](http://images.cnblogs.com/cnblogs_com/whitewolf/201012/201012231245237287.png)。其实在ASP.NET MVC 3.0中有多处了一个更简洁语法的模板-Razor，我们同样可以运用于我们自己的代码生成中，我随便有一篇简单的介绍[Razor Templating Engine](http://www.cnblogs.com/whitewolf/archive/2010/12/22/1913718.html)，在以后有机会了会写Razor Demo。今天的主题不在这里，所以不多说了。

### 一：简介：

CodeDom：这 个类库出现在我们的.NET Framework 2.0，并且被深深的用于我们的ASP.NET项目中。CodeDom关注于一个语言独立性，以至于我们可以利用我们熟悉的语言（c#，vb等）构建一个CodeDom Model Tree,就可以生成我们在.NET平台所支持的语言代码。对于我们的ASP.NET要求语言的独立。

T4：T4模板作为VS2008的一部分出现，他以&lt;# #&gt; 、&lt;#= #&gt;接近于ASP.NET的语言在模板中插入一段段的动态代码块，可以像asp或者ASP.NET一样简单的更让人贴切，相对于CodeDom就更简洁，但是没有了语言层次的抽象，不具有语言独立性，我们必须为同一个功能的模板在不同的语言上写不同的模板，但是在开发中往往c#模板就足够了，以及更简单化所以得到了更多人的青睐。

二：Code Demo：

下面我们将用CodeDom和t4分别生成一个简单的Code，根据时间输出不同的问候，如下：

1：CodeDom Code:

 

    using System; 
    using System.Text; 
    using System.CodeDom; 
    using System.IO;

    namespace RazorDemo 
    { 
        public class CodedomDemo 
        { 
            public CodeCompileUnit CrateCodeCompileUnit() 
            { 
                var testClass = new CodeTypeDeclaration("Test"); 
                var testMeth = new CodeMemberMethod() 
                { 
                    Attributes = MemberAttributes.Public| MemberAttributes.Final, 
                    Name = "SayHello", 
                }; 
                var param = new CodeParameterDeclarationExpression(new CodeTypeReference(typeof(string)), "name"); 
                testMeth.Parameters.Add(param); 
                testClass.Members.Add(testMeth);

                var nowExpression = new CodePropertyReferenceExpression(new CodePropertyReferenceExpression(new CodeTypeReferenceExpression(typeof(DateTime)), "Now"), "Hour"); 
                var assmon = new CodeBinaryOperatorExpression(new CodePrimitiveExpression("早上好:"), CodeBinaryOperatorType.Add, new CodeArgumentReferenceExpression("name") ); 
                var asslunch = new CodeBinaryOperatorExpression(new CodePrimitiveExpression("中午好:"), CodeBinaryOperatorType.Add, new CodeArgumentReferenceExpression("name")); 
                var assAfternoon = new CodeBinaryOperatorExpression(new CodePrimitiveExpression("下午好:"), CodeBinaryOperatorType.Add, new CodeArgumentReferenceExpression("name")); 
                var codecondition = new CodeConditionStatement(new CodeBinaryOperatorExpression( 
                    nowExpression, CodeBinaryOperatorType.LessThanOrEqual, new CodePrimitiveExpression(10)), 
                    new CodeStatement[] { new CodeExpressionStatement(new CodeMethodInvokeExpression(new CodeTypeReferenceExpression(typeof(Console)), "WriteLine", assmon)) },           //true:if(DateTime.Now<=10) 
                    //else 
                    new CodeStatement[] 
                    { 
                       new CodeConditionStatement(new CodeBinaryOperatorExpression(nowExpression, CodeBinaryOperatorType.LessThanOrEqual,new CodePrimitiveExpression(14) ),  // else if(DateTime.Now<=14) 
                         new CodeStatement[] { new CodeExpressionStatement(new CodeMethodInvokeExpression(new CodeTypeReferenceExpression(typeof(Console)), "WriteLine",asslunch))},    //true 
                         new CodeStatement[] { new CodeExpressionStatement(new CodeMethodInvokeExpression(new CodeTypeReferenceExpression(typeof(Console)), "WriteLine",assAfternoon))}) //fasle 
                    } 
                   );

                testMeth.Statements.AddRange(new CodeStatement[] {             
                codecondition 
                });

                var ns = new CodeNamespace("Wolf"); 
                ns.Imports.Add(new CodeNamespaceImport("System")); 
                ns.Types.Add(testClass); 
                var util = new CodeCompileUnit(); 
                util.Namespaces.Add(ns); 
                return util; 
            }

            public string Genertor(string language) 
            { 
                StringBuilder sb = new StringBuilder(); 
                StringWriter sw = new StringWriter(sb); 
                System.CodeDom.Compiler.CodeDomProvider.CreateProvider(language).GenerateCodeFromCompileUnit( 
                    this.CrateCodeCompileUnit(), sw, new System.CodeDom.Compiler.CodeGeneratorOptions() 
                    { 
                        ElseOnClosing = true, 
                        IndentString = "    " 
                    }); 
                sw.Close(); 
                return sb.ToString();

            } 
        } 
    }

2:T4 Code：



    <#@ template language="C#" #>

    using System; 
    namespace WolfT4 {   
        public class Test {

            public void SayHello(string name) { 
                <# if(System.DateTime.Now.Hour<=10){#> 
                System.Console.WriteLine(("早上好:" + name)); 
                <#} else if(System.DateTime.Now.Hour<=14){#> 
                System.Console.WriteLine(("中午好:" + name)); 
                <#} else{ #> 
                System.Console.WriteLine(("下午好:" + name)); 
                <#}#>            
            } 
        } 
    }

&nbsp;三：总结：

CodeDom的优势：

1：具有语言层次抽象，独立性：是一个单语言开发，多语言生成的方式。

2：**Framework **的支持：作为我们的.NET Framework 一部分出现的，位于System.CodeDom命名空间下。不需要想T4 模板一样引用Microsoft.VisualStudio.TextTemplating.dll 

T4优势：

1：更加贴切：采用的是类似于ASP、ASP.NET的语言块，是的我们的开发更贴切，采用模板方式更加简洁，快速。

2：可维护性：由于是基于文件，不像codedom编译成为dll方式，我们可以随时修改Template文件、重构。

&nbsp;

其实我觉得只要是不要求语言独立性，多语言生成的话，就采用T4或者Razor等模板。

代码生成技术（目前完成，还在继续，好久没写了...）：

1：[<font color="#6699cc">CodeDom系列目录</font>](http://www.cnblogs.com/whitewolf/archive/2010/07/09/1774279.html)

2：[<font color="#6699cc">CodeSmith模板引擎系列-目录</font>](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836729.html)

3：[<font color="#6699cc">Razor Templating Engine</font>](http://www.cnblogs.com/whitewolf/archive/2010/12/22/1913718.html) 

&nbsp;

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/12/23/1914700.html "原文首发")