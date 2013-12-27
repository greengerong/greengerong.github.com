---
layout: post
title: "Dynamic Linq 的Like扩展"
description: "Dynamic Linq 的Like扩展"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 在上几节Linq动态组合查询时，在肖坤的[Linq动态查询与模糊查询（带源码示例）](http://www.cnblogs.com/killuakun/archive/2008/08/03/1259389.html)时看到了微软的《[Linq to SQL Dynamic 动态查询](http://www.cnblogs.com/cnblogsfans/archive/2008/04/01/1132918.html)》，但是楼主说&#8220;可惜Dynamic.cs也是不能使用like的，恨啊！&#8221;。于是我下载了Dynamic .cs仔细研究了下源码，一步一步的调试，本想在微软的类库里添加如like的支持，但是调试了半天，还是无从下手。但是发现了DLinq支持对方法的调用，支持 DataContext.Orders.Where("ShipCity.Contains(@0) ","test");于是想了下我能否用正则表达式匹配Like表达式，转化为string.Contains（）。就尝试Code。说句其实微软已经支持了，只是我们有一些还是习惯于Like &#8216;str&#8217;形式吧了。

&nbsp;&nbsp;&nbsp; 赶快进入主题-Code:

     /// <summary>
          /// 操作like帮助类，自己增加的；
          /// </summary>
          public class DynamicQueryableLikeHelper
          {
              public static string CheckLikeSattement(string predicate, ref  object[] values)
              {
                  MatchCollection matches = Regex.Matches(predicate.ToLower(),
      @"(?<item>(\s*like\s*((?<param1>(@[\d+]))|(?<param2>(((\')?\w+\'?))))))\s*((and)|(or)?)");
                  string s = predicate;
                  if (matches != null)
                  {
                      int offset = 0;
                      foreach (Match item in matches)
                      {
                          Group gitem = item.Groups["item"];
                          if (!string.IsNullOrEmpty(item.Groups["param1"].Value))
                          {
                              Group g = item.Groups["param1"];
                              string insertstr = ".Contains(" + g.Value + ")";
                              s = DynamicQueryableLikeHelper.ChangePredicate(s, insertstr, gitem, ref offset);

                          }
                          else if (!string.IsNullOrEmpty(item.Groups["param2"].Value))
                          {
                              Group g = item.Groups["param2"];
                              string insertstr = ".Contains(@" + values.Length + ")";
                              s = DynamicQueryableLikeHelper.ChangePredicate(s, insertstr, gitem, ref offset);
                              ArrayList list = new ArrayList(values);
                              list.Add(g.Value.Replace("\'", ""));
                              values = list.ToArray();//like对字符串操作所以没有考虑其他类型

                          }

                      }
                  }
                  return s;
              }

              public static string ChangePredicate(string s, string insertstr, Group gitem, ref int offset)
              {
                  string strremove = s.Remove(gitem.Index + offset, gitem.Length);
                  s = strremove.Insert(gitem.Index + offset, insertstr);
                  offset += insertstr.Length - gitem.Length;
                  return s;
              }
          }
&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在上面代码就是正则表达式的运用，很简单。其中唯一花费了我很多时间就是我在正则表达式匹配时和修改后的string的index不一致，本想用个假单方法实现，最后还是么有办法，就只有加入了一个offset偏移量，每次删除插入的差值的和。这里就把like &#8216;value&#8217; 转化为 property.Contains（value）；其实和like还是有差别的Contains其实只等于 &#8216;%value%&#8217;。但是这里提供了一个方案，同理我们可以实现为&#8216;%value&#8217; 为EndWith，&#8216;vakue%&#8217;为StartWith。由于在我们的应用中一般常用的为Contains所以暂时还么有扩展其他两个，等有时间再做（实现也简单就是判断有么有%和他的位置选择我们所转化的函数名）。

&nbsp;&nbsp;&nbsp;&nbsp; 为了在Dlinq里扩展我在where方法里面加入了传入条件字符串的转化。并加入了参数ignoreLike，默认为False。我怕的扩展有某些问题暂时还么有测试出来了，还有就是不想改变原类库。

&nbsp;&nbsp;&nbsp; 在我的扩展中支持ShipCity like @1 、ShipCity like 'don'、ShipCity like @0 两种形式，原来类库里面只支持第三种形式。我的前两者形式都是当做字符串处理的，因为我们的like操作一般都是对字符串操作，如果要支持其他类型可以转化类型，我以前写了一个类型属性转化的类，可以实现，但是我想这个问题么有必要。

在类库里面该的方法有（已经注释了，还是贴出来看看调用）:

&nbsp;

       public static IQueryable<T> Where<T>(this IQueryable<T> source, string predicate, params object[] values)
          {
              return (IQueryable<T>)Where((IQueryable)source, predicate, false, values);
              //TODO:添加False
          }

          public static IQueryable<T> Where<T>(this IQueryable<T> source, string predicate,
                  bool ignoreLike, params object[] values)
          //TOD:增加的方法，ignoreLike
          {
              return (IQueryable<T>)Where((IQueryable)source, predicate, ignoreLike, values);
          }

          public static IQueryable Where(this IQueryable source, string predicate, params object[] values)
          //TOD:增加的方法，ignoreLike,下面方法的忽略ignoreLike写法；
          {
              return Where(source, predicate, false, values);
          }
          public static IQueryable Where(this IQueryable source, string predicate,
                           bool ignoreLike, params object[] values)
          //TODO:改变参数ignoreLike
          {
              if (source == null) throw new ArgumentNullException("source");
              if (predicate == null) throw new ArgumentNullException("predicate");
              if (!ignoreLike)
              {
                  predicate = DynamicQueryableLikeHelper.CheckLikeSattement(predicate, ref values);
                  //TODO:增加语句；
              }
              LambdaExpression lambda = DynamicExpression.ParseLambda(source.ElementType,
                          typeof(bool), predicate, values);
              return source.Provider.CreateQuery(
                  Expression.Call(
                      typeof(Queryable), "Where",
                      new Type[] { source.ElementType },
                      source.Expression, Expression.Quote(lambda)));
          }

&nbsp;&nbsp; 只是TODO处就是我改变的。下面该测试测试下（数据库Northwind的orders表）。

&nbsp;

   	IQueryable<Orders> q = DataContext.Orders
 	 .Where("ShipCity like @1 and ShipCity like @0 or ShipCity 	like 'don' and ShipCity like 'don'
            and ShipCity like 'don'  or EmployeeID1 =1", "test 	", "test").OrderBy("ShipCity");
              //IQueryable<Orders> q = 	DataContext.Orders.Where("ShipCity.Contains(@0) ","test");
              	Console.WriteLine(DataContext.GetCommand(q).CommandText);
              
  为了测试多个我邮箱投个懒就把ShipCity like 'don' 赋值了多次。 
输出sql为：&nbsp;

      SELECT [t0].[OrderID], [t0].[CustomerID], [t0].[EmployeeID] AS [EmployeeID1], [t 0].[OrderDate], [t0].[RequiredDate], [t0].[ShippedDate], [t0].[ShipVia], [t0].[F reight], [t0].[ShipName], [t0].[ShipAddress], [t0].[ShipCity], [t0].[ShipRegion] , [t0].[ShipPostalCode], [t0].[ShipCountry] FROM [dbo].[Orders] AS [t0] WHERE (([t0].[ShipCity] LIKE @p0) AND ([t0].[ShipCity] LIKE @p1)) OR (([t0].[Shi pCity] LIKE @p2) AND ([t0].[ShipCity] LIKE @p3) AND ([t0].[ShipCity] LIKE @p4)) OR ([t0].[EmployeeID] = @p5) ORDER BY [t0].[ShipCity]&nbsp;

如果在类库中有和你的字符串等冲突就可以用ignoreLike为真，避免我的扩展。

最后希望大家一起帮我测试下，如果有什么问题请留言和Email：[破狼Email](&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#103;&#114;&#122;&#120;&#50;&#50;&#49;&#48;&#64;&#49;&#54;&#51;&#46;&#99;&#111;&#109;)指出，我好改变。

附带：扩展后的[Dynamic.cs](http://files.cnblogs.com/whitewolf/我扩展支持LIke的DLinq.rar)下载

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/08/03/1790954.html "原文首发")