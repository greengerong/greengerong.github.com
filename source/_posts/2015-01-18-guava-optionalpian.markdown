---
layout: post
title: "Guava-Optional篇"
date: 2015-01-18 14:05:36 +0800
comments: true
categories: [Guava, Java]
---
接上篇Guava之Joiner和Splitter，本篇将介绍Guava的另外一个有用的对象Optional<T>,这在Java中Google Guava首先给我们提出可空对象模型的。在其他语言如c#这是已经存在很久的模式，并包含在.net类库中Nullable<T>(Int?也是一个可空类型)。

##Null sucks

回到本文主题Optional。在我日常编程中NullPointerException是肯定是大家遇见最多的异常错误:

为此Doug Lea曾说过:

	Null sucks.

Sir C. A. R. Hoare也曾说过：

	I call it my billion-dollar mistake.

从上面我们能够足以看出NullPointerExceptiond的出现频率和可恨之处。因此在GOF的设计模式中我们也专门提出了空对象模式(或称特例模式)来应对这可恶的NullPointerExceptiond。空对象模式主要以返回一些*无意义并不影响处理逻辑的特定对象来替代null对象*，从而避免没必要的null对象的判断。
例如在计算一组员工的总共薪资的时候，对于返回的null对象则我们可以返回默认值为了*0*薪资的员工对象，那么我们就不需要做任何null的判断。

##员工薪资问题

那么在Guava的Optional又该怎么解决呢？在讲解Optional之前，让我们仍然以计算一组员工的总共薪资为例用原生java代码将来看看：

```java
	@Test
    public void should_get_total_age_for_all_employees() throws Exception {
        final List<Employee> list = Lists.newArrayList(new Employee("em1", 30), new Employee("em2", 40), null, new Employee("em4", 18));
        int sum = 0;
        for (Employee employee : list) {
            if (employee != null) {
                sum += employee.getAge();
            }
        }
        System.out.println(sum);

    }

    private class Employee {
        private final String name;
        private final int age;

        public Employee(String name, int age) {
            this.name = name;
            this.age = age;
        }

        public String getName() {
            return name;
        }

        public int getAge() {
            return age;
        }
    }
```

如果换成Guava Optional将如何：

```java
	 @Test
    public void should_get_total_age_for_all_employees() throws Exception {
        final List<Employee> list = Lists.newArrayList(new Employee("em1", 30),
        	  new Employee("em2", 40),
        	   null,
        	   new Employee("em4", 18));

        int sum = 0;
        for (Employee employee : list) {
            sum += Optional.fromNullable(employee).or(new Employee("dummy", 0)).getAge();
        }
        
        System.out.println(sum);
    }
```
从上面可以清晰看出，我们不在担心对象对空了，利用Optional的fromNullable创建了一个可空对象，并将其or上一个dummy的员工信息，所以在这里我们不在担心NullPointerExceptiond。

也许你会说和利用三目运算 ( _?_:_)没什么差别，在此例子中功能是的确是没多大差距，但是个人觉得Guava更有语义，更通用一些，而且满足很多空对象模式使用的场景。

##Optional API

*. OptionalObject.isPresent(): 返回对象是否有值。

*. Optional.absent(): 返回一个空Optional对象,isPresent() 将会返回false

*. Optional.of(): 创Optional对象，输入参数不能为null

*. Optional.fromNullable(): 创Optional对象，输入可以为null

*. OptionalObject.asSet(): 和Optional对象值合并，如果为null则返回size为0的Set

*. OptionalObject.or(): 和Optional对象值合并，如果为null为空加则返回or参数作为默认值

*. OptionalObject.orNull(): 和Optional对象值合并，如果为null为空加则返回Null作为默认值


上面的api都是我们在使用Optional的时候最常用的方法属性方法，注意如果我们创建了Optional对象，但是没有判断isPresent()是否存在，就直接get这是会抛异常的，这属于乱用Optional情况，和直接用Null并没什么差别。

```java
	final Optional<Object> obj = Optional.fromNullable(null);
    final Object o = obj.get();
```

同样Optional为空对象模式，可以添加默认值，null不会影响我们的处理，如果为null我们无法继续程序处理的情况，需要抛异常或者中断的的，还是需要抛异常、中断，利用Preconditions.checkNotNull等，而不是继续套一层Optional对象，这也属于乱用Optional之列。
