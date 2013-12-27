---
layout: post
title: "Dbml文件提取建表TSql-CodeSmith"
description: "Dbml文件提取建表TSql-CodeSmith"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 在昨天一个大学师弟，他问我能不能将LinqToSql文件转化为创建表的TSql语句，他是刚开始学习.NET，所以在网上下些示例看，但苦于没有数据库。所以就有了这一篇博客，作为我的Code生成技术的CodeSimth的最后一篇示例。在下一步Code 生成技术将转到Microsoft的T4模板，Code生成技术目前完成的有[CodeDom](http://www.cnblogs.com/whitewolf/archive/2010/07/09/1774279.html),[CodeSmith模板](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836729.html)，高手请不要拍砖，请直接跳过。

&nbsp;&nbsp;&nbsp;&nbsp; 在Linq2Sql的Dbml文件其实就是一个Xml文件，记录着数据库与生成Linq2SqlCode的数据信息，所以转化为TSql没有什么说的。我们需要提取其中的数据库信息，在转化为我们的Tsql，在这里建立了DBTable、DBColumn、DBAssociation三个实体类：

        代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/-->  1 using System; 
        using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 

        namespace DbmlToTable 
        { 
            public class DBTable 
            { 

                public DBTable() 
                { 
                    Columns = new List<DBColumn>(); 
                    this.Associations = new List<DBAssociation>(); 
                } 

                public string TableName 
                { 
                    get; 
                    set; 
                } 

                public List<DBColumn> Columns 
                { 
                    get; 
                    set; 
                } 

                public List<DBAssociation> Associations 
                { 
                    get; 
                    set; 
                } 

            } 

            public class DBColumn 
            { 
                public string Name 
                { 
                    get; 
                    set; 
                } 

                public string DBType 
                { 
                    get; 
                    set; 
                } 

                public bool IsPrimaryKey 
                { 
                    get; 
                    set; 
                } 

                public bool IsDbGenerated 
                { 
                    get; 
                    set; 
                } 

                public bool CanBeNull 
                { 
                    get; 
                    set; 
                } 
            } 

            public class DBAssociation 
            { 
                public string Name 
                { 
                    get; 
                    set; 
                } 

                public string ThisKey 
                { 
                    get; 
                    set; 
                } 

                public string OtherKey 
                { 
                    get; 
                    set; 
                } 

                public bool IsForeignKey 
                { 
                    get; 
                    set; 
                } 
            } 

            public class DBTableHlper 
            { 
                public static DBTable GetAssociationTable(List<DBTable> collection,string assName) 
                { 

                    return collection.Find(t => t.Associations.Find(a => !a.IsForeignKey && a.Name == assName) != null); 
                } 
            } 
        }

&nbsp;&nbsp;&nbsp; 其中DBTableHlper是由于我的Codesimth是2.0版本的，不能用lamdam表达式，所以我将它编译在程序集里面。

&nbsp;&nbsp; 建立了一个 将我们的dbml文件xml Document转化为实体类辅助类：

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/--> 1 using System; 
        using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 
        using System.Xml; 
        using System.Xml.Linq; 

        namespace DbmlToTable 
        { 

            public interface IDbTableCollectionHelper 
            { 
                List<DBTable> Transport(XElement element); 
            } 

            public class DbTableCollectionHelper : IDbTableCollectionHelper 
            { 
                #region IDbTableCollectionHelper 成员 

                public List<DBTable> Transport(XElement element) 
                { 
                    List<DBTable> collection = new List<DBTable>(); 
                    var tables = element.Elements(XName.Get("Table", "http://schemas.microsoft.com/linqtosql/dbml/2007%22)); 
                    foreach (var tab in tables) 
                    { 
                        DBTable t = new DBTable() { TableName = tab.Attribute("Name").Value }; 
                        var cols = tab.Element(XName.Get("Type", "http://schemas.microsoft.com/linqtosql/dbml/2007%22)).Elements(XName.Get(%22Column%22, "http://schemas.microsoft.com/linqtosql/dbml/2007%22)); 
                        foreach (var col in cols) 
                        { 
                            DBColumn c = new DBColumn() 
                            { 
                                CanBeNull = col.Attribute("CanBeNull") != null ? col.Attribute("CanBeNull").Value.ToLower() == "true" : false, 
                                DBType = col.Attribute("DbType") != null ? col.Attribute("DbType").Value : "", 
                                IsDbGenerated = col.Attribute("IsDbGenerated") != null ? col.Attribute("IsDbGenerated").Value.ToLower() == "true" : false, 
                                IsPrimaryKey = col.Attribute("IsPrimaryKey") != null ? col.Attribute("IsPrimaryKey").Value.ToLower() == "true" : false, 
                                Name = col.Attribute("Name") != null ? col.Attribute("Name").Value : "" 
                            }; 
                            t.Columns.Add(c); 
                        } 

                        var ass = tab.Element(XName.Get("Type", "http://schemas.microsoft.com/linqtosql/dbml/2007%22)).Elements(XName.Get(%22Association%22, "http://schemas.microsoft.com/linqtosql/dbml/2007%22)); 
                        foreach (var item in ass) 
                        { 
                            DBAssociation a = new DBAssociation() 
                            { 
                                Name = item.Attribute("Name") != null ? item.Attribute("Name").Value : "", 
                                OtherKey = item.Attribute("OtherKey") != null ? item.Attribute("OtherKey").Value : "", 
                                ThisKey = item.Attribute("ThisKey") != null ? item.Attribute("ThisKey").Value : "", 
                                IsForeignKey = item.Attribute("IsForeignKey") != null ? item.Attribute("IsForeignKey").Value.ToLower() == "true" : false 
                            }; 
                            t.Associations.Add(a); 
                        } 
                        collection.Add(t); 
                    } 
                    return collection; 
                } 

                #endregion 
            } 
        }

&nbsp;&nbsp; 在转化为我们的实体类，我们剩下的就是编写我们的CodeSmith模板了（更多知识可以参考[CodeSmith模板](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836729.html)）：

         代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/--> 1 <%@ CodeTemplate Language="C#" TargetLanguage="Text" Src="" Inherits="" Debug="False" Description="Template description here." %> 

        <%@ Import NameSpace="System" %> 
        <%@ Import NameSpace="System.Xml" %> 
        <%@ Import NameSpace="System.Text" %> 
        <%@ Import NameSpace="System.Collections.Generic" %> 
        <%@ Assembly Name="DbmlToTable" %> 

        --Code By Wolf 
        <script runat="template"> 
        private List<DbmlToTable.DBTable> _DbTableCollection; 
        public List<DbmlToTable.DBTable> DbTableCollection 
        { 
            get 
            { 
                return _DbTableCollection; 
            } 
            set    
            { 
                _DbTableCollection=value; 
            } 
        } 

        public  string GeneratorTableSql(List<DbmlToTable.DBTable> collection) 
        { 
            StringBuilder sb = new StringBuilder(); 
            StringBuilder sbAssocation = new StringBuilder(); 
            foreach (DbmlToTable.DBTable item in collection) 
            { 
                List<string> cols = new List<string>(); 
                foreach (DbmlToTable.DBColumn  col in item.Columns) 
                { 
                    cols.Add(string.Format("{0} {1} {2} ", col.Name, col.DBType, col.IsPrimaryKey ? "PRIMARY KEY " : "")); 
                } 
                sb.AppendFormat("\r\nCREATE TABLE {0} \r\n(\r\n{1}\r\n)", item.TableName, string.Join(",\r\n", cols.ToArray())); 

                foreach (DbmlToTable.DBAssociation ass in item.Associations) 
                { 
                    if (ass.IsForeignKey) 
                    { 
                        DbmlToTable.DBTable tab = DbmlToTable.DBTableHlper.GetAssociationTable(collection,ass.Name); 
                        if (tab != null) 
                        { 
                            sbAssocation.AppendLine(); 
                            sbAssocation.AppendFormat(@"ALTER TABLE {0}  WITH NOCHECK ADD  CONSTRAINT {1} FOREIGN KEY({2}) REFERENCES {3} ({4})", 
                                item.TableName, "FK_" + ass.Name, ass.ThisKey, tab.TableName, ass.OtherKey); 
                        } 
                    } 
                } 
            } 

            return sb.ToString() + "\r\n" + sbAssocation.ToString(); 
        } 
        </script> 
        <%= this.GeneratorTableSql(_DbTableCollection) %>

&nbsp;&nbsp;&nbsp; 在codeSimth中我们建立了一个集合属性传递实体类DBTable和一个转化TSql辅助方法.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在控制台调用编译模板以及输出：

        代码 

        Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/--> 1 using System; 
        using System.Collections.Generic; 
        using System.Linq; 
        using System.Text; 

        namespace DbmlToTable 
        { 
            class Program 
            { 
                static void Main(string[] args) 
                { 
                    IDbTableCollectionHelper helper = new DbTableCollectionHelper(); 
                    List<DBTable> collection = helper. 
                        Transport(System.Xml.Linq.XElement.

                 Load(@"xxpath\MultipleDocument.Data\MultipleDocumentDB.dbml")); 

                    CodeSmith.Engine.CodeTemplate template = CodeSimthTemplateHelper. 
                        CompileTemplate(@"DBMLToTable.cst", w => Console.WriteLine(w)); 
                    if (template != null) 
                    { 
                        CodeSimthTemplateHelper.AddPropertyParams(template, new { DbTableCollection = collection }); 
                        string str = template.RenderToString(); 
                        Console.WriteLine(str); 
                        //System.IO.File.AppendAllText(@"D:\1.sql", str); 
                    } 
                    Console.Read(); 
                }

        }

&nbsp;&nbsp; 在CodeSimth中就是这么简单，生成相应的模板代码（个人理解CodeSmith就是把代码作为字符串输出）。

在上面到我的CodeSmith模板编译辅助类，在上一篇[通过代码生成机制实现强类型编程-CodeSmith版](http://www.cnblogs.com/whitewolf/archive/2010/09/25/1834317.html)也有，在这里也附带上：需要引用CodeSmith.Engine.dll.

        代码 

            Code highlighting produced by Actipro CodeHighlighter (freeware)http://www.CodeHighlighter.com/--> 1 using System; 

            using System.Collections.Generic; 

            using System.Linq; 

            using System.Text; 

            using CodeSmith.Engine; 

            using Wolf.NameValueDictionary; 

            namespace DbmlToTable 

            { 

            public class CodeSimthTemplateHelper 

            { 

                 public static CodeTemplate CompileTemplate(string templateName, Action errorWriter) 

                 { 

                       CodeTemplateCompiler compiler = new CodeTemplateCompiler(templateName); compiler.Compile(); 

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

             

            public static void AddPropertyParams(CodeTemplate template,object param) 

            { 

                  NameValueDictionary dict = new NameValueDictionary<object>(param);

                   AddPropertyParams(template, dict);

            }

             

            public static void AddPropertyParams(CodeTemplate template, NameValueDictionary<object> param)

            {

                      NameValueDictionary<object> dict = new NameValueDictionary<object>(param);

                      foreach (var item in dict.Keys)

                      {

                            template.SetProperty(item, dict[item]);

                       }

            }

            }

            }
            
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/09/27/1836731.html "原文首发")