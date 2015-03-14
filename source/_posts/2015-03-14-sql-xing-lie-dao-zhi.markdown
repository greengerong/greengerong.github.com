---
layout: post
title: "SQL 行列倒置"
date: 2015-03-14 17:06:28 +0800
comments: true
categories: [SQL]
---
SQL的的行列倒置已经不是新知识了，但在博主的技术咨询期间，仍发现其实有很多人并不了解这块，所以在此专门写一篇博客记录。本文将以Mysql为例，并以数据采集指标信息获取为例子。在下面的例子，你可以在sqlfiddle运行。

首先我们需要创建数据库Schema：
	

		CREATE TABLE Chart
			(`createTime` DateTime, `kpi` varchar(30), `field` varchar(30), `value` double);
			
		INSERT INTO Chart
			(`createTime`,`kpi`, `field`, `value`)
		VALUES
			("2015-02-01 12:00:00", 'disk', 'disk', 20),
		    ("2015-02-01 12:15:00", 'disk', 'disk', 30),
		    ("2015-02-01 12:20:00", 'disk', 'disk', 25),
		    ("2015-02-01 12:30:00", 'disk', 'disk', 25),
		    ("2015-02-01 12:35:00", 'disk', 'disk', 25),
		    ("2015-02-01 12:40:00", 'disk', 'disk', 25),
		     
		    ("2015-02-01 12:00:00", 'disk', 'disk-all', 20),
		    ("2015-02-01 12:20:00", 'disk', 'disk-all', 30),
		    ("2015-02-01 12:25:00", 'disk', 'disk-all', 25),
		    ("2015-02-01 12:30:00", 'disk', 'disk-all', 25),
		    ("2015-02-01 12:35:00", 'disk', 'disk-all', 25),
		    ("2015-02-01 12:40:00", 'disk', 'disk-all', 25),
		    ("2015-02-01 12:40:00", 'cpu', 'cpu-all', 25),
		    ("2015-02-01 12:40:00", 'cpu', 'cpu', 25)
		;


在这里字段分别代表：createTime = 数据采集时间，kpi = 数据采集指标，field = 作为指标的小类(一个kpi可以包含多个field)，value = 采集的数据

当我们创建好了数据结构，下面因为我们希望获取出所有的 固定时间范围内的特定kpi的数据，注意因为可能一个kpi中的多个field，但是某些field漏采了部分时间的数据，所以这里我们需要补充异常点0. 并由于EChart这类图表库，希望我们输入的是横轴和纵轴为两个独立的数组对象表示。所以我们需要如下：

	option = {
	    ....

	    xAxis : [
	        {
	            type : 'category',
	            boundaryGap : false,
	            data : ['周一','周二','周三','周四','周五','周六','周日']
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value',
	            axisLabel : {
	                formatter: '{value} °C'
	            }
	        }
	    ],
	    series : [
	        {
	            ....
	            data:[11, 11, 15, 13, 12, 13, 10]
	        },
	        {
	           ....
	            data:[11, 11, 15, 13, 12, 13, 10]
	        }
	    ]
	};
        
取出横轴比较容易，如下：

	SELECT createTime,kpi, field, value FROM Chart WHERE kpi = 'disk' and (createTime BETWEEN '2015-02-01 12:00:00' AND '2015-02-01 12:25:00');

但是纵轴如果我们以同样方式取出，可能存在需要我们自动程序补值，并且需要保证每项数据和横轴对应，所以我们的程序处理会比较复杂，如下：

    SELECT createTime,kpi, field, value FROM Chart WHERE kpi = 'disk' and (createTime BETWEEN '2015-02-01 12:00:00' AND '2015-02-01 12:25:00');

结果为：

	createTime	kpi	field	value
	February, 01 2015 12:00:00	disk	disk	20
	February, 01 2015 12:15:00	disk	disk	30
	February, 01 2015 12:20:00	disk	disk	25
	February, 01 2015 12:00:00	disk	disk-all	20
	February, 01 2015 12:20:00	disk	disk-all	30
	February, 01 2015 12:25:00	disk	disk-all	25

有没有其他方案更佳的呢？当然那就是本文要说的sql的倒置，如果我们能够把返回数据转换为如下：

	field	‘2015-02-01 12:00:00’	‘2015-02-01 12:15:00’	‘2015-02-01 12:20:00’	‘2015-02-01 12:25:00’
	disk	     20	                           30	                  25	                   0
	disk-all	 20                          	0	                  30	                   25


那么程序就很好处理了。在上面我们已经能够取出所有的横轴数据并排序，接下来我们将可以很简单的做到行列倒置：如下：

	SELECT field,
	SUM(IF(createTime = '2015-02-01 12:00:00', value, 0)) as '2015-02-01 12:00:00',
	SUM(IF(createTime = '2015-02-01 12:15:00', value, 0)) as '2015-02-01 12:15:00',
	SUM(IF(createTime = '2015-02-01 12:20:00', value, 0)) as '2015-02-01 12:20:00',
	SUM(IF(createTime = '2015-02-01 12:25:00', value, 0)) as '2015-02-01 12:25:00' 
	FROM Chart
	WHERE kpi = 'disk' and (createTime BETWEEN '2015-02-01 12:00:00' AND '2015-02-01 12:25:00')
	GROUP BY field

这样返回数据满足我们的需求了。

下面我们来分析下这句SQL，

1. 首先我们利用‘IF(createTime = '2015-02-01 12:00:00', value, 0)’来处理插值，并对每行数据转为以时间为列数据,并可以利用IF来补’0‘，将会如下：

SQL：

	SELECT field,
	IF(createTime = '2015-02-01 12:00:00', value, 0) as '2015-02-01 12:00:00',
	IF(createTime = '2015-02-01 12:15:00', value, 0) as '2015-02-01 12:15:00',
	IF(createTime = '2015-02-01 12:20:00', value, 0) as '2015-02-01 12:20:00',
	IF(createTime = '2015-02-01 12:25:00', value, 0) as '2015-02-01 12:25:00' 
	FROM Chart
	WHERE kpi = 'disk' and (createTime BETWEEN '2015-02-01 12:00:00' AND '2015-02-01 12:25:00');


结果为：

	field	‘2015-02-01 12:00:00’	‘2015-02-01 12:15:00’	‘2015-02-01 12:20:00’	‘2015-02-01 12:25:00’
	disk			   20						0						0						0
	disk				0						30						0						0
	disk				0						0						25						0
	disk-all			20						0						0						0
	disk-all			0						0						30						0
	disk-all			0						0						0						25


2. 这下我们就可以利用sql的聚合函数sum和group by来聚合数据行：


SQL:

	SELECT field,
	SUM(IF(createTime = '2015-02-01 12:00:00', value, 0)) as '2015-02-01 12:00:00',
	SUM(IF(createTime = '2015-02-01 12:15:00', value, 0)) as '2015-02-01 12:15:00',
	SUM(IF(createTime = '2015-02-01 12:20:00', value, 0)) as '2015-02-01 12:20:00',
	SUM(IF(createTime = '2015-02-01 12:25:00', value, 0)) as '2015-02-01 12:25:00' 
	FROM Chart
	WHERE kpi = 'disk' and (createTime BETWEEN '2015-02-01 12:00:00' AND '2015-02-01 12:25:00')
	GROUP BY field

效果如上。

对于sql行列转置可以简述为分为两部分：

1. 利用条件逻辑(mysql： IF， sql server： case ... when ..)将 需要倒置的数据变为列。
2. 利用聚合函数(sum、max、min...)group by 合并数据。这里需要注意max、min需要注意数据的边界，如存在负数且默认值采用0，那么max就会存在问题，所以一般sum是最安全的(任何数加0都不会改变结果)；但对于特定场景max、min也是安全方案。



