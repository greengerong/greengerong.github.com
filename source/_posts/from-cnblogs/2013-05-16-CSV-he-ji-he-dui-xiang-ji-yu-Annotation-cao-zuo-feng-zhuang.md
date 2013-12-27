---
layout: post
title: "CSV和集合对象基于Annotation操作封装"
description: "CSV和集合对象基于Annotation操作封装"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 随着项目上线，暂时处于闲置状态，所以趁闲带着团队对在这一年项目中做的比较好的组件，工具和实践总结和抽取出来，在我后续的随笔中将会陆续发布出来。今天主要是一个简单的maven小组件，对opencsv基于Annotation简单的封装，使得我们可以轻易的将CSV文件转化为List对像和把List对像导出为CSV文件。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 项目托管地址于github [https://github.com/greengerong/opencsv-utils](https://github.com/greengerong/opencsv-utils)。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 对于代码就不用多说了，简单看看如何使用。

	package opencsv.utils;

 

	public class Person {

 

    private int id;

 

    @Csv("person name")

    private String name;

 

    @Ignore

    private int age;

 

    public Person(int id, String name, int age) {

        this.id = id;

        this.name = name;

        this.age = age;

    }

 

    public Person() {

 

    }

 

    public int getId() {

        return id;

    }

 

    public void setId(int id) {

        this.id = id;

    }

 

    public String getName() {

        return name;

    }

 

    public void setName(String name) {

        this.name = name;

    }

 

    public int getAge() {

        return age;

    }

 

    public void setAge(int age) {

        this.age = age;

    }

	}
	

&nbsp;

Mapping会自动将没有ignore的字段作为CSV的映射属性名作为CSV列头，如果针对特殊列则可以标记@CSV解决。

1： 读取CSV:

(1) 基于Annotation映射方式

 	
 	 @Test

    public void shouldGetPersonFromCSV() throws Exception {

        StringReader reader = new StringReader("id,person name\n1,name1\n2,name2\n");

        List<Person> personList = personCsvMapper

                .withMapping("id", "id")

                .withMapping("person name", "name")

                .fromCsv(reader);

 

        assertThat(personList.size(), is(2));

 

        final Person first = personList.get(0);

        assertThat(first.getId(), is(1));

        assertThat(first.getName(), is("name1"));

 

        final Person second = personList.get(1);

        assertThat(second.getId(), is(2));

        assertThat(second.getName(), is("name2"));

 

    }
   

(2) 自定义映射方式&nbsp;


	@Test

    public void shouldToCsv() throws Exception {

        personCsvMapper.withMapping(new CsvColumnMapping(Person.class));

        final ArrayList<Person> list = new ArrayList<Person>();

        list.add(new Person(1, "name1", 20));

        list.add(new Person(2, "name2", 30));

        final StringWriter writer = new StringWriter();

 

        personCsvMapper.toCsv(writer, list);

 

        final String text = writer.toString();

        assertThat(text, is("id,person name\n1,name1\n2,name2\n"));

    }
    


2: CSV输出

	@Test

    public void shouldGetPersonFromCsv() throws Exception {

        StringReader reader = new StringReader("id,person name\n1,name1\n2,name2\n");

        List<Person> personList = new CsvMapper<Person>(Person.class)

                .withMapping(new CsvColumnMapping(Person.class))

                .fromCsv(reader);

 

        assertThat(personList.size(), is(2));

 

        final Person first = personList.get(0);

        assertThat(first.getId(), is(1));

        assertThat(first.getName(), is("name1"));

 

        final Person second = personList.get(1);

        assertThat(second.getId(), is(2));

        assertThat(second.getName(), is("name2"));

 

    }
    
    
最后在累赘下托管地址:[https://github.com/greengerong/opencsv-utils](https://github.com/greengerong/opencsv-utils)。其他的相比不用再说了。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/05/16/3082700.html "原文首发")