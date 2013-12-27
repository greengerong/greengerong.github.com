---
layout: post
title: "Silverlight获取WebHost配置信息--WebClient和XmlSerializer模拟"
description: "Silverlight获取WebHost配置信息--WebClient和XmlSerializer模拟"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; 在我们的silverlight项目中，是被打包为xap zip文件下载到客户端，所以silverlight中的app配置文件我们不能直接修改，而在其宿主web host中的web.config在服务端我们也不能直接访问。在我们的项目中遇见了这个问题所以我就有了此博客。

&nbsp;&nbsp; 先说明解决这个问题的方案有：

1：调用wcf，webservice，Asp.net页面等服务端数据源，异步显示在我们的UI。

2：利用silverlight项目的宿主页面 object，传入初始化参数，在silverlight app中获取。

上面的方案都是针对于我们的少量有限配置信息的获取。我这里做的是利用在服务端的xml配置文件来模拟配置文件（为什么不用web.config？以为存在权限信息的问题，所以我觉得尽量避免此文件信息暴露）。在silverlight的异步加载xml文档并解析xml文档。形成配置信息。

为了全局使用，早些加载xml文档，我们需要在app中加一句：

SLConfigManager.Current.ConfigPath = "../SlConfig.xml";//配置文件的路径，相对于我们的xap文件路径。

我们先看一下测试xml：

      <?xml version="1.0" encoding="utf-8" ?> 
    <Configuration> 
      <appSettings> 
        <add key="test1" value="123"></add> 
        <add key="test2" value="1"></add> 
      </appSettings> 
      <Class ClassID="111"> 
        <Student Age="123"> 
          <Name>ddddd</Name>     
        </Student> 
        <Student  Age="28"> 
          <Name>111</Name>     
        </Student> 
      </Class> 
    </Configuration>

这是我们可以使用：

    void Page1_Loaded(object sender, RoutedEventArgs e) 
         { 
             MessageBox.Show(SLConfigManager.Current.GetSection<Class>("Class").ClassID + ""); 
             MessageBox.Show(SLConfigManager.Current.GetAppSettings("test1").ToString()); 
             MessageBox.Show(SLConfigManager.Current.GetAppSettings<Sex>("test2").ToString()); 
         } 

            public enum Sex 
         { 
          man,woman 
         }
         
在这里我们模拟了AppSettings，和Section（注：这里的section，不需要预申明，在利用xml转化形成的，更利于我们的配置扩展性，使用到了XmlRoot，XmlElement等attribute），在看看我们的Class类：

    using System.Xml.Serialization; 

  namespace SilverlightApplication2 
  { 
      [XmlRoot("Student")] 
      public class Student 
      { 
          [XmlElement("Name")] 
          public string Name 
          { get; set; } 

          [XmlAttribute("Age")] 
          public int Age 
          { 
              get; 
              set; 
          } 
      } 

      [XmlRoot("Class")] 
      public class Class 
      { 
          [XmlAttribute("ClassID")] 
          public int ClassID 
          { 
              get; 
              set; 
          } 

          [XmlArray()] 
          [XmlArrayItem("Students")] 
          public System.Collections.Generic.List<Student> Students 
          { 
              get; 
              set; 
          } 
      } 
  }

最后需要说明的是：在于我们的项目中可能存在xml文件还没有加载，的情况，所以加入了时间支持和IsLoaded属性标示。

源码：

  	using System; 
    using System.Net; 
    using System.Windows; 
    using System.Windows.Controls; 
    using System.Windows.Documents; 
    using System.Windows.Ink; 
    using System.Windows.Input; 
    using System.Windows.Media; 
    using System.Windows.Media.Animation; 
    using System.Windows.Shapes; 
    using System.Xml; 
    using System.Xml.Linq; 
    using System.Linq; 
    using System.Collections.Generic; 
    using Green.Utility.Utils; 

    namespace SilverlightApplication2 
    { 
        public delegate void LoadComplete(); 

        public class SLConfigManager 
        { 
            private XDocument document = null; 

            private static readonly SLConfigManager _SLConfigManager = new SLConfigManager(); 
            private Dictionary<string, object> dict = new Dictionary<string, object>(); 
            private Dictionary<string, string> appSettings = new Dictionary<string, string>(); 
            private string _ConfigPath = null; 

            public static SLConfigManager Current 
            { 
                get 
                { 
                    return _SLConfigManager; 
                } 
            } 

            public string ConfigPath 
            { 
                get { return _ConfigPath; } 
                set 
                { 
                    if (_ConfigPath != value) 
                    { 
                        _ConfigPath = value; 
                        LoadResource(); 
                    } 
                } 
            } 

            public bool IsLoaded 
            { 
                get; 
                private set; 
            } 
            public event LoadComplete LoadComplete; 

            public void EnsureLoadResource() 
            { 

                if (document == null) 
                { 
                    LoadResource(); 
                } 
            } 

            protected virtual void LoadResource() 
            { 
                if (string.IsNullOrEmpty(ConfigPath)) 
                { 
                    throw new Exception("ConfigPath is required!"); 
                } 

                dict.Clear(); 
                Uri url = new Uri(Application.Current.Host.Source, ConfigPath); 
                WebClient client = new WebClient(); 
                client.OpenReadCompleted += new OpenReadCompletedEventHandler(client_OpenReadCompleted); 
                client.OpenReadAsync(url, client); 
            } 

            protected virtual void client_OpenReadCompleted(object sender, OpenReadCompletedEventArgs e) 
            { 
                if (e.Error != null) 
                { 
                    throw e.Error; 
                } 

                var sw = new System.IO.StreamReader(e.Result); 
                var xml = sw.ReadToEnd(); 
                document = XDocument.Parse(xml); 
                sw.Close(); 
                e.Result.Close(); 
                sw = null; 

                GetappSettings(); 

                IsLoaded = true; 
                if (LoadComplete != null) 
                { 
                    LoadComplete(); 
                } 
            } 

            protected virtual void GetappSettings() 
            { 
                if (document != null) 
                { 
                    var appSettingsel = document.Root.Element("appSettings"); 
                    if (appSettings != null) 
                    { 
                        appSettingsel.Elements("add").ToList().ForEach(e => 
                        { 
                            var key = e.Attribute("key").Value; 
                            var value = e.Attribute("value").Value; 
                            if (!string.IsNullOrEmpty(key)&&!this.appSettings.ContainsKey(key)) 
                            { 
                                this.appSettings.Add(key, value); 
                            } 
                        }); 
                    } 
                } 
            } 

            public T GetSection<T>(string section) where T : class ,new() 
            { 
                if (document == null) 
                { 
                    // throw new Exception("Config Document is null!");                
                } 
                if (!dict.ContainsKey(section)) 
                { 
                    var el = document.Root.Descendants().SingleOrDefault(t => t.Name == section); 
                    var xml = el.ToString(); 
                    dict.Add(section, XmlSerializer<T>(xml)); 
                } 
                return dict[section] as T; 
            } 

            protected virtual T XmlSerializer<T>(string xml) where T : class ,new() 
            { 
                System.Xml.Serialization.XmlSerializer serialzer = new System.Xml.Serialization.XmlSerializer(typeof(T)); 
                System.IO.MemoryStream ms = new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(xml)); 
                var obj = serialzer.Deserialize(ms) as T; 
                ms.Flush(); 
                ms.Close(); 
                ms = null; 
                return obj; 
            } 

            public T GetAppSettings<T>(string key) where T : IConvertible 
            { 
                if (appSettings.ContainsKey(key)) 
                { 
                    var val = this.appSettings[key]; 
                    if (string.IsNullOrEmpty(val)) 
                        return default(T); 
                    if (typeof(T).IsEnum) 
                    { 
                        return (T)Enum.Parse(typeof(T), val, true); 
                    } 
                    return (T)Convert.ChangeType(val, typeof(T), null); 
                } 
                return default(T); 
            } 

            public string GetAppSettings(string key) 
            { 
                return GetAppSettings<string>(key); 
            } 
        } 
    }

最后附：[测试程序打包下载](http://files.cnblogs.com/whitewolf/SilverlightApplication2.rar "测试程序打包下载")

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2011/07/06/SlConfig.html "原文首发")