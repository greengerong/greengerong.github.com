---
layout: post
title: "Linq多表查询条件批量删除"
description: "Linq多表查询条件批量删除"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 前阵写了Linq的单表生成相对Sql执行的批量删除，总觉得删除条件太局限了，并且又不能屏蔽linq的级联条件，这很容易误导一些人。所以想了应该还是要支持才好。呵呵。

&nbsp;&nbsp;&nbsp;&nbsp; 其实思路和上次一样，就是生成Sql，用Linq自身条件组合sql应用，没有什么好说的。组合sql用 EXISTS关键字，组合一个子查询。

	 DELETE FROM [TableName]   WHERE   EXISTS(select ..from 		[TableName]  where query );

&nbsp;

直接上Code：

 	/// EXISTS
    /// &lt;/summary&gt;
    /// &lt;typeparam name="T"&gt;&lt;/typeparam&gt;
    /// &lt;param name="source"&gt;&lt;/param&gt;
    /// &lt;param name="query"&gt;&lt;/param&gt;
    /// &lt;returns&gt;&lt;/returns&gt;
    public static int Delete&lt;T&gt;(this System.Data.Linq.Table&lt;T&gt; source, Expression&lt;Func&lt;T, bool&gt;&gt; query)
    where T : class
    {
    if (source == null)
    throw new ArgumentException("source");
    if (query == null)
    throw new ArgumentException("query");
    //query = t =&gt; true;
    //为空DELETE  FROM [dbo].[test] 全删除；个人觉得为空全删除，很不人道，所以还是抛异常
    System.Data.Linq.DataContext db = source.Context;
    DbCommand cmd= db.GetCommand(source.Where(query));
    string queryStr = cmd.CommandText;
    string sql = "DELETE FROM " + source.Context.Mapping.GetTable(typeof(T)).TableName + " WHERE   EXISTS(" + queryStr+")";
    List&lt;object&gt; dbparams = new List&lt;object&gt;();
    foreach (SqlParameter item in cmd.Parameters)
    {
    SqlParameter p = new SqlParameter(item.ParameterName, item.SqlDbType, item.Size);
    p.Value = item.Value;
    dbparams.Add(item.Value);
    }
    cmd = null;
    return db.ExecuteCommand(sql, dbparams.ToArray());
    }
&nbsp; 调用方式就很简单了，一个Lamdam表达式，就搞定。比如

	Console.Write( DataContext.test.Delete(t =&gt; t.id != null||t.name.Contains("qq")&amp;&amp;t.Orders.OrderDate&lt;=DateTime.Now));

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/WindowsLiveWriter/Linq_138F4/image_thumb.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/WindowsLiveWriter/Linq_138F4/image_2.png) 

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp; 例子没有从重写Linq或者扩展Linq表达式出发，因为从这里出发我能力估计还差一筹，呵呵还是我觉得没有必要，这样的实现是否更简单，实现的功能更多些，为何不重用人家MS的东西呢，个人观点而已

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/09/15/1826624.html "原文首发")