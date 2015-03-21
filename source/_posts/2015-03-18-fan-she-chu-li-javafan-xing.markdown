---
layout: post
title: "(翻译)反射处理java泛型"
date: 2015-03-18 21:08:30 +0800
comments: true
categories: [java]
---


当我们声明了一个泛型的接口或类，或需要一个子类继承至这个泛型类，而我们又希望利用反射获取这些泛型参数信息。这就是本文将要介绍的**ReflectionUtil**就是为了解决这类问题的辅助工具类，为**java.lang.reflect**标准库的工具类。它提供了便捷的访问泛型对象类型(java.reflect.Type)的反射方法。

本文假设你已经了解java反射知识，并能熟练的应用。如果还不了解java反射知识，那么你可以先移步到[Oracel反射课程](http://docs.oracle.com/javase/tutorial/reflect),这可能是你开始学习反射的好起点.

ReflectionUtil中包含以下几种功能：

1. 通过Type获取对象class;
2. 通过Type创建对象;
3. 获取泛型对象的泛型化参数;
4. 检查对象是否存在默认构造函数;
5. 获取指定类型中的特定field类型;
6. 获取指定类型中的特定method返回类型;
7. 根据字符串标示获取枚举常量;
8. ReflectionUtil下载地址.

##通过Type获取对象class

```java
	private static final String TYPE_NAME_PREFIX = "class ";
	 
	public static String getClassName(Type type) {
	    if (type==null) {
	        return "";
	    }
	    String className = type.toString();
	    if (className.startsWith(TYPE_NAME_PREFIX)) {
	        className = className.substring(TYPE_NAME_PREFIX.length());
	    }
	    return className;
	}
	 
	public static Class<?> getClass(Type type) 
	            throws ClassNotFoundException {
	    String className = getClassName(type);
	    if (className==null || className.isEmpty()) {
	        return null;
	    }
	    return Class.forName(className);
	}
```

方法ReflectionUtil#getClass(Type)实现了从**java.lang.reflect.Type**获取**java.lang.Class**对象名称。这里利用了Type的toString方法获取所在类型的class。如**"class some.package.Foo"**,截取后部分class名称，在利用**Class.forName(String)**获取class对象。


##通过Type创建对象

```java
	public static Object newInstance(Type type) 
	        throws ClassNotFoundException, InstantiationException, IllegalAccessException {
	    Class<?> clazz = getClass(type);
	    if (clazz==null) {
	        return null;
	    }
	    return clazz.newInstance();
	}
```

方法ReflectionUtil#newInstance(Type type)实现根据Type构造对象实例。在这里输入的Type不能是抽象类、接口、数组类型、以及基础类型、Void否则会发生InstantiationException异常。


##获取泛型对象的泛型化参数

首先假设我们有如下两个对象：

```java
	public abstract class Foo<T> {
	    //content
	}

	public class FooChild extends Foo<Bar> {
	    //content
	} 
```


怎么获取子类在Foo中传入的泛型Class<T>类型呢？

比较常用的做法有以下两种：

####强制FooChild传入自己的class类型(这也是比较常用的做法)：

```java
	public abstract class Foo<T> {
	    private Class<T> tClass;    

	    public Foo(Class<T> tClass) {
	        this.tClass = tClass;
	    }
	    //content
	}

	public class FooChild extends Foo<Bar> {
	    public FooChild() {
	        super(FooChild.class);
	    }
	    //content
	} 
```

####利用反射获取：

```java
	public static Type[] getParameterizedTypes(Object object) {
	    Type superclassType = object.getClass().getGenericSuperclass();
	    if (!ParameterizedType.class.isAssignableFrom(superclassType.getClass())) {
	        return null;
	    }
	    return ((ParameterizedType)superclassType).getActualTypeArguments();
	}
```


方法ReflectionUtil#getParameterizedTypes(Object)利用反射获取运行时泛型参数的类型，并数组的方式返回。本例中为返回一个T类型的Type数组。

为了Foo得到T的类型我们将会如下使用此方法：

```java
	...
	Type[] parameterizedTypes = ReflectionUtil.getParameterizedTypes(this);
	Class<T> clazz = (Class<T>)ReflectionUtil.getClass(parameterizedTypes[0]);
	...
```

**注意**:

在java.lang.reflect.ParameterizedType#getActualTypeArguments() documentation:的文档中你能看见如下文字：


	in some cases, the returned array can be empty. This can occur. if this type represents 
	a non-parameterized type nested within a parameterized type.


当传入的对象为非泛型类型，则会返回空数组形式。


##检查对象是否存在默认构造函数

```java
	public static boolean hasDefaultConstructor(Class<?> clazz) throws SecurityException {
	    Class<?>[] empty = {};
	    try {
	        clazz.getConstructor(empty);
	    } catch (NoSuchMethodException e) {
	        return false;
	    }
	    return true;
	}
```

方法ReflectionUtil#hasDefaultConstructor利用java.lang.reflect.Constructor检查是否存在默认的无参构造函数。

##获取指定类型中的特定field类型

```java
public static Class<?> getFieldClass(Class<?> clazz, String name) {
    if (clazz==null || name==null || name.isEmpty()) {
        return null;
    }
    name = name.toLowerCase();
    Class<?> propertyClass = null;
    for (Field field : clazz.getDeclaredFields()) {
        field.setAccessible(true);
        if (field.getName().equals(name)) {
            propertyClass = field.getType();
            break;
        }
    }
    return propertyClass;
}
```


在某些情况下你希望利用已知的类型信息和特定的字段名字想获取字段的类型，那么ReflectionUtil#getFieldClass(Class<?>, String)可以帮助你。ReflectionUtil#getFieldClass(Class<?>, String) 利用**Class#getDeclaredFields()**获取字段并循环比较**java.lang.reflect.Field#getName()**字段名称，返回字段所对应的类型对象。

##获取指定类型中的特定method返回类型

```java
	public static Class<?> getMethodReturnType(Class<?> clazz, String name) {
	    if (clazz==null || name==null || name.isEmpty()) {
	        return null;
	    }   
	 
	    name = name.toLowerCase();
	    Class<?> returnType = null;
	         
	    for (Method method : clazz.getDeclaredMethods()) {
	        if (method.getName().equals(name)) {
	            returnType = method.getReturnType();
	            break;
	        }
	    }
	         
	    return returnType;
	}
```


方法ReflectionUtil#getMethodReturnType(Class<?>, String)可以帮助你根据对象类型和方法名称获取其所对应的方法返回类型。ReflectionUtil#getMethodReturnType(Class<?>, String)利用**Class#getDeclaredMethods()**并以**java.lang.reflect.Method#getName()**比对方法名称，返回找到的方法的返回值类型(Method#getReturnType()).


##根据字符串标示获取枚举常量

```java
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object getEnumConstant(Class<?> clazz, String name) {
	    if (clazz==null || name==null || name.isEmpty()) {
	        return null;
	    }
	    return Enum.valueOf((Class<Enum>)clazz, name);
	}

```

方法ReflectionUtil#getEnumConstant(Class<?>, String)为利用制定的枚举类型和枚举名称获取其对象。这里的名称必须和存在的枚举常量匹配。

##ReflectionUtil下载地址

你可以从这里下载[ReflectionUtil.java](http://qussay.com/wp-content/uploads/2013/09/ReflectionUtil.java).
原英文版地址： http://qussay.com/2013/09/28/handling-java-generic-types-with-reflection/
