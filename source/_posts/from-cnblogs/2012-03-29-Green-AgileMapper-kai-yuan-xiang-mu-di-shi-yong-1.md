---
layout: post
title: "Green.AgileMapper开源项目的使用(1)"
description: "Green.AgileMapper开源项目的使用(1)"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在架构设计中，利用领域驱动开发时，涉及到do（领域对象）和dto（数据传输对象）的相互装换匹配，这段代码简单但是重复频率太多，写得我很冒火（我有个职责是wcf SOA包装），我是个不喜欢重复劳动的懒人，我在网上搜索等到很多实体匹配的框架EmitMapper，AutoMapper等，但是他们都不能满足dto和do的对象的按规则匹配包装。最后我只得花了半个小时写了一个简单的代码生成器，完成了我的任务。但是事后总觉得不爽，于是有了写下这个AgileMapper框架来适应领域开发中的po，do，dto，vo着一些列对象的相互包装，建立一个按规则包装的Mapper框架。项目已经完成上传于CodePlex [http://agilemapper.codeplex.com/](http://agilemapper.codeplex.com/ "http://agilemapper.codeplex.com/") ，目前刚成型，希望大家能够帮助测试，提出bug，或者修复。我不是很清楚开源协议，选择了一个 协议。大家可以随便使用和修改应用来满足各自的需求，但是如果有些bug修复或者好的通用的修改希望大家能够，提交供我和其他人学习共同进步，但是这不是必须的，你也可以选择保留。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AgileMapper架构设计类图：


![AgileMapper](http://images.cnblogs.com/cnblogs_com/whitewolf/201203/201203291333323869.png "AgileMapper")

&nbsp;&nbsp;&nbsp; 在AgileMapper中支持多种MappingConfigurator（匹配管理器）都集成至MappingConfiguratorBase（MappingConfiguratorBase中拥有唯一的对象之间对于相等的默认表达式守信，针对于dto转化为do对象级联删除情况），内置了AttributeMappingConfigurator，XMLMappingConfigurator，DataRowMappingConfigurator三种匹配管理器。支持xml书写，attribute标记规则。由这些管理器根据具体标记标记方式产生一组IMappingRule（匹配规则），内置了5中匹配规则（简单，集合，表达式，对象，datarow）。

&nbsp;&nbsp; 在AgileMapper为我们提供了MappingConfiguratorBase的扩展，IMappingRule的扩展，已经多余Attribute标注的扩展CustomerMappingAttribute，已经xml的配置扩展。

下面我们来使用AgileMapper提供的内置Mapper。

测试预备：

Domain Object：

 	
 	public class StudenDo 

   	{ 

       public int ID 

       { 

           get; 

           set; 

       } 



       public string Name 

       { get; set; } 



       public Sex Sex 

       { get; set; } 



       public Address Address 

       { get; set; } 



       public ContactWay ContactWay 

       { get; set; } 



       public List<string> CourseIds 

       { get; set; } 



       public List<KeyValuePair> Propertys 

       { get; set; } 



   	} 



   	public class KeyValuePair 

   	{ 

       public string Key 

       { get; set; } 



       public string Value 

       { get; set; } 

   	} 



  	 public enum Sex 

   	{ 

       男, 女 

  	 }



 	public class ContactWay 
	
   	{ 

      public string Phone 

      { 

          get; 

          set; 

      } 



      public string Email 

      { 

          get; 

          set; 

      } 



      public string QQ 

      { 

          get; 

          set; 

      } 

   	}


	public class Address 

  	 { 

       public string Country 

       { 

           get; 

           set; 

       } 



       public string Province 

       { get; set; } 



       public string Street 

       { get; set; } 



       public string Particular 

       { get; set; } 

   	}

Dto：

	public class StudenDto 

       { 

           public int ID 

           { 

               get; 

               set; 

           } 



           public string Name 

           { get; set; } 



           public Sex Sex 

           { get; set; } 



           [Mapping("Address.Country")] 

           public string Country 

           { 

               get; 

               set; 

           } 



           [Mapping("Address.Province")] 

           public string Province 

           { get; set; } 



           // [Mapping("Address.Street")] 

           [IgnoreMapping] 

           public string Street 

           { get; set; } 



           [ExpressionMapping("Address.Country +\" 国籍 \"+Address.Province +\" 省 \"")] 

           public string Particular 

           { get; set; } 



           [ObjectMappingAttribute] 

           public ContactWayDto ContactWay 

           { get; set; } 



           [CollectionMapping()] 

           public List<string> CourseIds 

           { get; set; } 



           [CollectionMapping(EqualExpression="from.Key==to.Key",IsDeleteNotInFromItem=true)] 

           public List<KeyValuePair> Propertys 

           { get; set; } 



           [ExpressionMapping("Propertys[0].Key")] 

           public string FirstPropertyKey 

           { 

               get; 

               set; 

           } 



     



    public class ContactWayDto 

        { 

            public string Phone 

            { 

                get; 

                set; 

            } 



            public string Email 

            { 

                get; 

                set; 

            } 



            public string QQ 

            { 

                get; 

                set; 

            } 

        }



    public class AddressDto 

    { 

        public string Country 

        { 

            get; 

            set; 

        } 



        public string Province 

        { get; set; } 



        public string Street 

        { get; set; } 



        public string Particular 

        { get; set; } 

    }

一：Attribute标注：

  		
  			[TestMethod] 

         public void AttributeConfig_SimpleMapping_Gen() 

         { 



             StudenDo stu = new StudenDo() 

             { 

                 ID = 1, 

                 Name = "test1", 

                 Sex = Sex.女, 

                 Address = new Address() 

                 { 

                     Country = "中国", 

                     Province = "四川", 

                     Street = "高新区" 

                 }, 

                 CourseIds = new List<string>() { "1", "2", "3" }, 

                 Propertys = new List<KeyValuePair>() { new KeyValuePair() { Key = "1", Value = "1" } }, 

                 ContactWay = new ContactWay() 

                 { 

                     Phone = "1111111111111111", 

                     Email = "xxxx@12f", 

                     QQ = "7889789999889" 

                 } 

             }; 



             var mapper = ObjectMapperManager.Default.GetMapper<StudenDto, StudenDo>(); 



             var dt1 = DateTime.Now; 

             var stuDto = mapper.Warp(stu); 

             var sp = DateTime.Now - dt1; 



             dt1 = DateTime.Now; 

             stuDto = mapper.Warp(stu); 

             var sp1 = DateTime.Now - dt1; 



             Assert.AreEqual(stuDto.ID, stu.ID); 

             Assert.AreEqual(stuDto.Name, stu.Name); 

             Assert.AreEqual(stuDto.Sex, stu.Sex); 

             Assert.AreEqual(stuDto.Country, stu.Address.Country); 

             Assert.AreEqual(stuDto.Province, stu.Address.Province); 

             Assert.AreEqual(stuDto.Street, null);//Ignore 

             //object 

             // Assert.AreEqual(stuDto.ContactWay,null); 

             Assert.AreEqual(stuDto.ContactWay.QQ, stu.ContactWay.QQ); 

             Assert.AreEqual(stuDto.ContactWay.Email, stu.ContactWay.Email); 

             //expression 

             Assert.AreEqual(stuDto.Particular, string.Format("{0} 国籍 {1} 省 ", stu.Address.Country, stu.Address.Province)); 

             Assert.AreEqual(stuDto.FirstPropertyKey, stu.Propertys[0].Key); 

             //collection            

             Assert.AreEqual(stuDto.CourseIds[0], stu.CourseIds[0]); 

             Assert.AreEqual(stuDto.CourseIds.Count, stu.CourseIds.Count); 



             Assert.AreEqual(stuDto.Propertys[0].Key, stu.Propertys[0].Key); 

             Assert.AreEqual(stuDto.Propertys[0].Value, stu.Propertys[0].Value); 

             Assert.AreEqual(stuDto.Propertys.Count, stu.Propertys.Count); 



             //Warp 2 

             var stuDo = new StudenDo(); 

             mapper.Warp(stuDto, stuDo); 



             Assert.AreEqual(stuDo.ID, stuDto.ID); 

             Assert.AreEqual(stuDo.Name, stuDto.Name); 

             Assert.AreEqual(stuDo.Sex, stuDto.Sex); 

             Assert.AreEqual(stuDo.Address.Country, stuDto.Country); 

             Assert.AreEqual(stuDo.Address.Province, stuDto.Province); 

             //Assert.AreEqual(stuDo.Address.Street, null);//Ignore 

             //object 

             Assert.AreEqual(stuDo.ContactWay.QQ, stuDto.ContactWay.QQ); 

             Assert.AreEqual(stuDo.ContactWay.Email, stuDto.ContactWay.Email); 

             //collection 



             Assert.AreEqual(stuDo.CourseIds.Count, stuDto.CourseIds.Count); 

             Assert.AreEqual(stuDo.CourseIds[0], stuDto.CourseIds[0]); 



             Assert.AreEqual(stuDo.Propertys.Count, stuDto.Propertys.Count); 

             Assert.AreEqual(stuDo.Propertys[0].Key, stuDto.Propertys[0].Key); 

             Assert.AreEqual(stuDo.Propertys[0].Value, stuDto.Propertys[0].Value); 

         } 



         [TestMethod] 

         public void AttributeConfig_SimpleMapping() 

         { 

             StudenDo stu = new StudenDo() 

             { 

                 ID = 1, 

                 Name = "test1", 

                 Sex = Sex.女, 

                 Address = new Address() 

                 { 

                     Country = "中国", 

                     Province = "四川", 

                     Street = "高新区" 

                 }, 

                 CourseIds = new List<string>() { "1", "2", "3" }, 

                 Propertys = new List<KeyValuePair>() { new KeyValuePair() { Key = "1", Value = "1" } }, 

                 ContactWay = new ContactWay() 

                 { 

                     Phone = "1111111111111111", 

                     Email = "xxxx@12f", 

                     QQ = "7889789999889" 

                 } 

             }; 



             var mapper = ObjectMapperManager.Default.GetMapper(); 

             var stuDto = mapper.Warp(typeof(StudenDto), stu) as StudenDto; 



             Assert.AreEqual(stuDto.ID, stu.ID); 

             Assert.AreEqual(stuDto.Name, stu.Name); 

             Assert.AreEqual(stuDto.Sex, stu.Sex); 

             Assert.AreEqual(stuDto.Country, stu.Address.Country); 

             Assert.AreEqual(stuDto.Province, stu.Address.Province); 

             Assert.AreEqual(stuDto.Street, null);//Ignore 

             //object 

             Assert.AreEqual(stuDto.ContactWay.QQ, stu.ContactWay.QQ); 

             Assert.AreEqual(stuDto.ContactWay.Email, stu.ContactWay.Email); 

             //expression 

             Assert.AreEqual(stuDto.Particular, string.Format("{0} 国籍 {1} 省 ", stu.Address.Country, stu.Address.Province)); 

             //collection            

             Assert.AreEqual(stuDto.CourseIds[0], stu.CourseIds[0]); 

             Assert.AreEqual(stuDto.CourseIds.Count, stu.CourseIds.Count); 

         }

二：xml配置标注规则：&nbsp;


  	<?xml version="1.0" encoding="utf-8" ?> 

    <AgileMapper> 

      <Extensions> 

        <Extension Name="SimpleMappingRule" Type="Green.AgileMapper.SimpleMappingRule,Green.AgileMapper"></Extension> 

        <Extension Name="ObjectMappingRule" Type="Green.AgileMapper.ObjectMappingRule,Green.AgileMapper"></Extension> 

        <Extension Name="CollectionMappingRule" Type="Green.AgileMapper.CollectionMappingRule,Green.AgileMapper"></Extension> 

        <Extension Name="ExpressionMappingRule" Type="Green.AgileMapper.ExpressionMappingRule,Green.AgileMapper"></Extension> 

      </Extensions> 

      <Mappings> 

        <Mapping FromType="AgileMapper.Test.StudenDto,AgileMapper.Test"  > 

          <SimpleMappingRule FromPoperty="Country" ToPoperty="Address.Country"></SimpleMappingRule> 

          <SimpleMappingRule FromPoperty="Province" ToPoperty="Address.Province"></SimpleMappingRule>           

          <ObjectMappingRule  FromPoperty="ContactWay" ToPoperty="ContactWay"></ObjectMappingRule> 

          <CollectionMappingRule FromPoperty="CourseIds" ToPoperty="CourseIds"></CollectionMappingRule> 

          <CollectionMappingRule FromPoperty="Propertys" ToPoperty="Propertys" EqualExpression="from.Key==to.Key" IsDeleteNotInFromItem="true"></CollectionMappingRule> 

          <ExpressionMappingRule  FromPoperty="Particular" Expression="Address.Country +Address.Province"></ExpressionMappingRule> 

          <ExpressionMappingRule  FromPoperty="FirstPropertyKey" Expression="Propertys[0].Key"></ExpressionMappingRule> 

          <Ignores> 

            <Ignore Name="Street"></Ignore> 

          </Ignores> 

        </Mapping> 

      </Mappings> 

    </AgileMapper>

测试代码：


[TestMethod] 

        public void XMlConfig_SimpleMapping_Gen() 

        { 



            StudenDo stu = new StudenDo() 

            { 

                ID = 1, 

                Name = "test1", 

                Sex = Sex.女, 

                Address = new Address() 

                { 

                    Country = "中国", 

                    Province = "四川", 

                    Street = "高新区" 

                }, 

                CourseIds = new List<string>() { "1", "2", "3" }, 

                Propertys = new List<KeyValuePair>() { new KeyValuePair() { Key = "1", Value = "1" } }, 

                ContactWay = new ContactWay() 

                { 

                    Phone = "1111111111111111", 

                    Email = "xxxx@12f", 

                    QQ = "7889789999889" 

                } 

            }; 



            var mapper = ObjectMapperManager.Default.GetMapper<StudenDto, StudenDo>(new XMLMappingConfigurator(@"E:\Project\OpenSource\AgileMapper\AgileMappper.Test\XMLConfigurator\AgileMapper.xml")); 



            var stuDto = mapper.Warp(stu);           



            Assert.AreEqual(stuDto.ID, stu.ID); 

            Assert.AreEqual(stuDto.Name, stu.Name); 

            Assert.AreEqual(stuDto.Sex, stu.Sex); 

            Assert.AreEqual(stuDto.Country, stu.Address.Country); 

            Assert.AreEqual(stuDto.Province, stu.Address.Province); 

            Assert.AreEqual(stuDto.Street, null);//Ignore 

            //object 

            // Assert.AreEqual(stuDto.ContactWay,null); 

            Assert.AreEqual(stuDto.ContactWay.QQ, stu.ContactWay.QQ); 

            Assert.AreEqual(stuDto.ContactWay.Email, stu.ContactWay.Email); 

            //expression 

            Assert.AreEqual(stuDto.Particular.Replace(" ", ""), string.Format("{0}{1}", stu.Address.Country, stu.Address.Province)); 

            Assert.AreEqual(stuDto.FirstPropertyKey, stu.Propertys[0].Key); 

            //collection            

            Assert.AreEqual(stuDto.CourseIds[0], stu.CourseIds[0]); 

            Assert.AreEqual(stuDto.CourseIds.Count, stu.CourseIds.Count); 



            Assert.AreEqual(stuDto.Propertys[0].Key, stu.Propertys[0].Key); 

            Assert.AreEqual(stuDto.Propertys[0].Value, stu.Propertys[0].Value); 

            Assert.AreEqual(stuDto.Propertys.Count, stu.Propertys.Count); 



            //Warp 2 

            var stuDo = new StudenDo(); 

            mapper.Warp(stuDto, stuDo); 



            Assert.AreEqual(stuDo.ID, stuDto.ID); 

            Assert.AreEqual(stuDo.Name, stuDto.Name); 

            Assert.AreEqual(stuDo.Sex, stuDto.Sex); 

            Assert.AreEqual(stuDo.Address.Country, stuDto.Country); 

            Assert.AreEqual(stuDo.Address.Province, stuDto.Province); 

            //Assert.AreEqual(stuDo.Address.Street, null);//Ignore 

            //object 

            Assert.AreEqual(stuDo.ContactWay.QQ, stuDto.ContactWay.QQ); 

            Assert.AreEqual(stuDo.ContactWay.Email, stuDto.ContactWay.Email); 

            //collection 



            Assert.AreEqual(stuDo.CourseIds.Count, stuDto.CourseIds.Count); 

            Assert.AreEqual(stuDo.CourseIds[0], stuDto.CourseIds[0]); 



            Assert.AreEqual(stuDo.Propertys.Count, stuDto.Propertys.Count); 

            Assert.AreEqual(stuDo.Propertys[0].Key, stuDto.Propertys[0].Key); 

            Assert.AreEqual(stuDo.Propertys[0].Value, stuDto.Propertys[0].Value); 

        }
        
三：DataRow的测试：&nbsp; 

测试预备StudentModelForDataRow：


    public class StudentModelForDataRow 

      { 

          public int ID 

          { get; set; } 



          public string Name 

          { get; set; } 

      }

测试代码：&nbsp;


	    [TestMethod] 

         public void DataRowConfig_SameTable_DataRowCloneMapping() 

         { 

             DataTable dt = new DataTable(); 

             dt.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)) 

             }); 



             var row = dt.NewRow(); 

             row[0] = 1; 

             row[1] = "Green"; 

             dt.Rows.Add(row); 



             var rowClone = dt.NewRow(); 



             var mapper = ObjectMapperManager.Default.GetMapper(new DataRowMappingConfigurator()); 

             mapper.Warp(typeof(DataRow), row, rowClone); 

             Assert.AreEqual(row[0], rowClone[0]); 

             Assert.AreEqual(row[1], rowClone[1]); 

         } 



         [TestMethod] 

         public void DataRowConfig_UnSameTable_MutipleRule_DataRowCloneMapping() 

         { 

             DataTable dt = new DataTable(); 

             dt.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)) 

             }); 



             DataTable dt2 = new DataTable(); 

             dt2.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)), 

                  new DataColumn("Sex",typeof(string)) 

             }); 



             var row = dt2.NewRow(); 

             row[0] = 1; 

             row[1] = "Green"; 

             row[2] = "Nan"; 

             dt2.Rows.Add(row); 



             var rowClone = dt.NewRow(); 



             var mapper = ObjectMapperManager.Default.GetMapper(new DataRowMappingConfigurator()); 

             mapper.Warp(row, rowClone); 

             Assert.AreEqual(row[0], rowClone[0]); 

             Assert.AreEqual(row[1], rowClone[1]); 

         } 



         [TestMethod] 

         public void DataRowConfig_UnSameTable_Not_MutipleRule_DataRowCloneMapping() 

         { 

             DataTable dt = new DataTable(); 

             dt.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)) 

             }); 



             DataTable dt2 = new DataTable(); 

             dt2.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)), 

                  new DataColumn("Sex",typeof(string)) 

             }); 



             var row = dt.NewRow(); 

             row[0] = 1; 

             row[1] = "Green"; 

             dt.Rows.Add(row); 



             var rowClone = dt2.NewRow(); 



             var mapper = ObjectMapperManager.Default.GetMapper(new DataRowMappingConfigurator()); 

             mapper.Warp(row, rowClone); 

             Assert.AreEqual(row[0], rowClone[0]); 

             Assert.AreEqual(row[1], rowClone[1]); 

         } 



         [TestMethod] 

         public void DataRowConfig_To_Object_CloneMapping() 

         { 

             DataTable dt = new DataTable(); 

             dt.Columns.AddRange(new DataColumn[] { 

                 new DataColumn("ID",typeof(int)), 

                 new DataColumn("Name",typeof(string)) 

             }); 



             var row = dt.NewRow(); 

             row[0] = 1; 

             row[1] = "Green"; 

             dt.Rows.Add(row); 

             StudentModelForDataRow model = new StudentModelForDataRow(); 



             var mapper = ObjectMapperManager.Default.GetMapper(new DataRowMappingConfigurator()); 

             mapper.Warp(row, model); 

             Assert.AreEqual(model.ID, row[0]); 

             Assert.AreEqual(model.Name, row[1]); 

         }

&nbsp;&nbsp;&nbsp;&nbsp; DataRow匹配针对相同的表结构和不同表结构，以及实体类和DataRow之间的转化。&nbsp; 

单元测试结果：

[![QQ截图未命名](http://images.cnblogs.com/cnblogs_com/whitewolf/201203/20120329133348267.png "QQ截图未命名")](http://images.cnblogs.com/cnblogs_com/whitewolf/201203/201203291333394223.png) 

&nbsp;&nbsp;&nbsp;&nbsp; 对于xml配置的架构还没做，以及基于T4模板的按照规则代码生成模板还在进一步开发中，敬请期待。

&nbsp;&nbsp;&nbsp;&nbsp; 今天就写在这里了，欢迎大家的指正和修改，希望你的修改如果更好能通知我，给我好的建议和探讨，谢谢。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/03/29/AgileMapper1.html "原文首发")