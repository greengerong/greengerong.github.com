---
layout: post
title: "利用Attribute简化Unity框架IOC注入"
description: "利用Attribute简化Unity框架IOC注入"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在我们的领域驱动设计(DDD)开发中,我们经常需要IOC框架使得我的框架依赖翻转，依赖抽象，避免直接new依赖于我们的具体实现。这些使得我们的框架整个项目结构不变，很方便的改变具体实现，使得项目提供可测试性，模块之间实现高内聚低耦合，减少我们的后期维护成本。IOC框架一般基于容器，在容器中存储着各个抽象和具体实现的依赖关系，当我们需要发出请求的时候，IOC框架会在当前容器中找到我们所需要的具体实现返回给我们，当然这里还有DI注入（属性，方法，构造），在我们的使用者（客户端）不需要了解具体实现，如何初始化，如何流转等具体，只需明白我们的契约接口暴露给我们的服务，IOC框架是解决抽象和具体直接的创建问题。其他资料可以参见**[Inversion of Control Containers and the Dependency Injection pattern](http://martinfowler.com/articles/injection.html)。**

&nbsp;&nbsp;&nbsp;&nbsp; 当然Unity框架中为我们提供了RegisterInstance，RegisterType方法我们可以在代码中注册到容器，比如NLayerApp中就在`IoCFactory中注册一大堆抽象-具体关联。但是在我们的实际实践中一般会选择另一种方式xml配置配置，因为这样我们会得到更大的灵活性，需求变化只要抽象接口不变，我们也只需要在xml配置文件中修改一行配置加入我们的具体实现，加入我们的程序集，就可以适应需求变化，这更满足oo设计&#8220;开闭原则&#8221;。`

`&nbsp;&nbsp; 在这里个人实践利用抽象（接口）定义Attribute制定具体ConfigFile（配置文件），Container（容器），Name（名称）解决IOC植入，减少我们多次去读取配置文件。Unity为我们提供了在Web.config,App.config中配置注入信息，或者注册外部配置，但是很多时候我们更希望，在我们的 不同模块下，应用不同的IOC配置信息，这些可以减少维护的关联少些，清晰，同时文件夹的出现便于我们的配置信息的管理。`

`Attribute实现：UnityInjectionAttribute`

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Interface, AllowMultiple = false, Inherited = true)] 

       public class UnityInjectionAttribute : Attribute 

       { 



           public UnityInjectionAttribute(string Container) 

           { 

               this.Container = Container;            

           } 



           public string Container 

           { 

               get; 

               set; 

           } 



           public string ConfigFile 

           { 

               get; 

               set; 

           } 



           public string Name 

           { 

               get; 

               set; 

           } 



           public Microsoft.Practices.Unity.Configuration.UnityConfigurationSection GetUnityConfigurationSection() 

           { 

               if (!string.IsNullOrEmpty(this.ConfigFile)) 

               { 

                   var fileMap = new System.Configuration.ExeConfigurationFileMap { ExeConfigFilename = System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, this.ConfigFile) }; 

                   System.Configuration.Configuration configuration = System.Configuration.ConfigurationManager.OpenMappedExeConfiguration(fileMap, System.Configuration.ConfigurationUserLevel.None); 

                   return configuration == null ? null : configuration.GetSection(Microsoft.Practices.Unity.Configuration.UnityConfigurationSection.SectionName) as Microsoft.Practices.Unity.Configuration.UnityConfigurationSection; 

               } 

               return System.Configuration.ConfigurationManager.GetSection(Microsoft.Practices.Unity.Configuration.UnityConfigurationSection.SectionName) as Microsoft.Practices.Unity.Configuration.UnityConfigurationSection; 

           } 

       }

&nbsp; 在这里我们GetUnityConfigurationSection根据ConfigFile获取UnityConfigurationSection ，ConfigFile为空则当前应用配置文件，不空则为路径。在这里我们为了性能，减少过多的IOC操作，读取配置文件，我们可以更具具体需要加入对配置文件UnityConfigurationSection的缓存（ConfigFile作为key，UnityConfigurationSection为value ）。

&nbsp;&nbsp; 同时提供操作辅助方法：ELUnityUtility

     public static class ELUnityUtility 

       { 

           public static T Resolve<T>() where T : class 

           { 

               return Resolve(typeof(T)) as T; 

           } 



           public static object Resolve(this Type type) 

           { 

               var attrs = type.GetCustomAttributes(typeof(Utils.UnityInjectionAttribute), true) as Utils.UnityInjectionAttribute[]; 

               if (attrs != null && attrs.Length > 0) 

               { 

                   var attr = attrs[0]; 

                   var unitySection = attr.GetUnityConfigurationSection(); 

                   if (unitySection != null) 

                   { 

                       var container = new Microsoft.Practices.Unity.UnityContainer().LoadConfiguration(unitySection, string.IsNullOrEmpty(attr.Container) ? unitySection.Containers.Default.Name : attr.Container); 

                       var obj = string.IsNullOrEmpty(attr.Name) ? container.Resolve(type) : container.Resolve(type, attr.Name); 

                       if (obj != null) 

                       { 

                           var piabAtttr = obj.GetType().GetCustomAttributes(typeof(ELPolicyinjectionAttribute), false) as ELPolicyinjectionAttribute[]; 

                           if (piabAtttr.Length > 0) 

                           { 

                               obj = Microsoft.Practices.EnterpriseLibrary.PolicyInjection.PolicyInjection.Wrap(type, obj); 

                           } 

                           return obj; 

                       } 

                   } 

               } 

               return null; 

           } 



           public static IEnumerable<T> ResolveAll<T>() where T : class 

           { 

               return ResolveAll(typeof(T)) as IEnumerable<T>; 

           } 



           public static object ResolveAll(this Type type) 

           { 

               var attrs = type.GetCustomAttributes(typeof(Utils.UnityInjectionAttribute), true) as Utils.UnityInjectionAttribute[]; 

               if (attrs != null && attrs.Length > 0) 

               { 

                   var attr = attrs[0]; 

                   var unitySection = attr.GetUnityConfigurationSection(); 

                   if (unitySection != null) 

                   { 

                       var container = new Microsoft.Practices.Unity.UnityContainer().LoadConfiguration(unitySection, string.IsNullOrEmpty(attr.Container) ? unitySection.Containers.Default.Name : attr.Container); 

                       return container.ResolveAll(type); 

                   } 

               } 

               return null; 

           } 



       }

<font face="Courier New">这里我们就可以很简便的获取IOC翻转。注：这里还有根据具体实现是否具体ELPolicyinjectionAttribute来决定是否进行PIAB的AOP操作，当然我们也可以在Unity配置文件中引入节点扩展</font>

Microsoft.Practices.Unity.InterceptionExtension.Configuration.InterceptionConfigurationExtension, 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Microsoft.Practices.Unity.Interception.Configuration

<font face="Courier New">（PIAB利用的是透明代理速度较慢所以一般很少使用，当然你也可以实现具体的PIAB AOP方式比如注入MSIL，但我们已经有了很多注入MSIL的AOP框架了，我不准备去造轮子），ELPolicyinjectionAttribute：</font>

     [AttributeUsage(AttributeTargets.Class)] 

       public class ELPolicyinjectionAttribute : Attribute 

       { 

           public string Name 

           { 

               get; 

               set; 

           } 

       }

这样：我们的客户端 就可以很简单的使用了：

     class Program 

       { 

           static void Main(string[] args) 

           { 



               ELUnityUtility.Resolve<IClass2>().Show(); 

               (typeof(IClass2).Resolve() as IClass2).Show(); 

               Console.Read(); 

           } 

       } 



       public interface IClass1 

       { 

           void Show(); 

       } 



       [Green.Utils.ELPolicyinjection] 

       public class Class1 : IClass1 

       { 



           #region IClass1 成员 

           [TestCallHandler] 

           public void Show() 

           { 

               Console.WriteLine(this.GetType()); 

           } 



           #endregion 

       } 



       [Green.Utils.UnityInjection("First", Name = "class2", ConfigFile = "App1.config")] 

       public interface IClass2 

       { 

           void Show(); 

       } 



        public class Class2 : ConsoleApplication1.IClass2 

       { 

           [Microsoft.Practices.Unity.Dependency("class1")] 

           public IClass1 Class1 

           { 

               get; 

               set; 

           } 



                public void Show() 

           { 

               Console.WriteLine(this.GetType()); 

               Class1.Show(); 

           } 

       }

App1.Config配置：


    <?xml version="1.0" encoding="utf-8" ?> 

    <configuration> 

      <configSections> 

        <section name="unity" 

                 type="Microsoft.Practices.Unity.Configuration.UnityConfigurationSection, 

                 Microsoft.Practices.Unity.Configuration"/> 

      </configSections> 

      <unity xmlns="http://schemas.microsoft.com/practices/2010/unity%22> 

        <container name="First"> 

          <register type="ConsoleApplication1.IClass1,ConsoleApplication1" mapTo="ConsoleApplication1.Class1,ConsoleApplication1" name="class1" /> 

          <register type="ConsoleApplication1.IClass2,ConsoleApplication1" mapTo="ConsoleApplication1.Class2,ConsoleApplication1" name="class2"  /> 

        </container> 

      </unity> 

    </configuration>

下边是一个完整的带PIAB的例子：

 
 using System; 

using System.Collections.Generic; 

using System.Linq; 

using System.Text; 

using Green.Utils; 

using Microsoft.Practices.Unity.InterceptionExtension; 

using Microsoft.Practices.EnterpriseLibrary.Common.Configuration; 



namespace ConsoleApplication1 

{ 

    class Program 

    { 

        static void Main(string[] args) 

        { 



            ELUnityUtility.Resolve<IClass2>().Show(); 

            (typeof(IClass2).Resolve() as IClass2).Show(); 

            Console.Read(); 

        } 

    } 



    public interface IClass1 

    { 

        void Show(); 

    } 



    [Green.Utils.ELPolicyinjection] 

    public class Class1 : IClass1 

    { 



        #region IClass1 成员 

        [TestCallHandler] 

        public void Show() 

        { 

            Console.WriteLine(this.GetType()); 

        } 



        #endregion 

    } 



    [Green.Utils.UnityInjection("First", Name = "class2", ConfigFile = "App1.config")] 

    public interface IClass2 

    { 

        void Show(); 

    } 



    [Green.Utils.ELPolicyinjection] 

    public class Class2 : ConsoleApplication1.IClass2 

    { 

        [Microsoft.Practices.Unity.Dependency("class1")] 

        public IClass1 Class1 

        { 

            get; 

            set; 

        } 



        [TestCallHandler] 

        public void Show() 

        { 

            Console.WriteLine(this.GetType()); 

            Class1.Show(); 

        } 

    } 



    [Microsoft.Practices.EnterpriseLibrary.Common.Configuration.ConfigurationElementType(typeof(CustomCallHandlerData))] 

    public class TestCallHandler : ICallHandler 

    { 

        #region ICallHandler 成员 



        public IMethodReturn Invoke(IMethodInvocation input, GetNextHandlerDelegate getNext) 

        { 

            if (input == null) throw new ArgumentNullException("input"); 

            if (getNext == null) throw new ArgumentNullException("getNext"); 

            Console.WriteLine("begin...."); 

            var result = getNext()(input, getNext); 

            Console.WriteLine("end...."); 

            return result; 

        } 



        public int Order 

        { 

            get; 

            set; 

        } 



        #endregion 

    } 



    [AttributeUsage(AttributeTargets.Method)] 

    public class TestCallHandlerAttribute : HandlerAttribute 

    { 

        public override ICallHandler CreateHandler(Microsoft.Practices.Unity.IUnityContainer container) 

        { 

            return new TestCallHandler(); 

        } 

    } 

	}


欢迎大家指正，批评，交流是的大家都功能进步。[代码下载](http://files.cnblogs.com/whitewolf/UnityInjectionAttribute.rar)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/11/29/2268379.html "原文首发")