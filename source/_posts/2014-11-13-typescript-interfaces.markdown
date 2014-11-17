---
layout: post
title: "TypeScript - Interfaces"
date: 2014-11-13 21:49:25 +0800
comments: true
categories: [TypeScript， JavaScript]
---
####简介
关注于数据值的 'shape'的类型检查是TypeScript核心设计原则。这种模式有时被称为‘鸭子类型’或者‘结构子类型化’。 在TypeScript中接口interfaces的责任就是命名这些类型，而且还是你的代码之间或者是与外部项目代码的契约。

##初见Interface

理解interface的最好办法，就是写个hello world程序：

	function printLabel(labelledObj: {label: string}) {
	  console.log(labelledObj.label);
	}

	var myObj = {size: 10, label: "Size 10 Object"};
	printLabel(myObj);

在这里类型检查系统会检查printLabel这个函数，printLabel函数要求传入一个包含一个label的字符串属性。上例可以了解我们传入的对象可以有多个属性，但是类型检查系统只会检查printLabel所要求的label属性是否满足其要求。

接下来我们可以进一步简化，声明一个interface来描述一个具有label字符串属性的对象：

	interface LabelledValue {
	  label: string;
	}

	function printLabel(labelledObj: LabelledValue) {
	  console.log(labelledObj.label);
	}

	var myObj = {size: 10, label: "Size 10 Object"};
	printLabel(myObj);

接口LabelledValue描述了上例中printLabel的所要求的类型对象。它依然代表包含一个label的字符串属性。可以看见我们利用‘shape’(行)描述了printLabel的传入参数要求。

##可选的Properties
有时不是所有定义在interface中的属性都是必须的。例如流行的"option bags"模式(option配置)，使用者可以之传入部分定制化属性。如下面“option bags”模式：

interface SquareConfig {
  color?: string;
  width?: number;
}

	function createSquare(config: SquareConfig): {color: string; area: number} {
	  var newSquare = {color: "white", area: 100};
	  if (config.color) {
	    newSquare.color = config.color;
	  }
	  if (config.width) {
	    newSquare.area = config.width * config.width;
	  }
	  return newSquare;
	}

	var mySquare = createSquare({color: "black"});

带有可选属性的interface定义和c#语言很相似，以'?'紧跟类型后边表示。

interface的可选属性可以限制那些属性是可用的，这部分能得到类型检查，以及智能感知。例如下例：

	interface SquareConfig {
	  color?: string;
	  width?: number;
	}

	function createSquare(config: SquareConfig): {color: string; area: number} {
	  var newSquare = {color: "white", area: 100};
	  if (config.color) {
	    newSquare.color = config.collor;  // 类型检查系统能识别不正确的属性collor.
	  }
	  if (config.width) {
	    newSquare.area = config.width * config.width;
	  }
	  return newSquare;
	}

	var mySquare = createSquare({color: "black"});  

##函数类型

Interfaces为了描述对象能接收的数据形(shapes)的返回。对于interface不仅难呢过描述对象的属性，也能描述函数类型。

下面是定义的interface signature是一个接收两个string的输入参数，并返回boolean的函数类型：

	interface SearchFunc {
	  (source: string, subString: string): boolean;
	}

我也可以使用函数类型的interface去描述我们的数据。下面演示如何将一个相同类型的函数赋值给interface：

	var mySearch: SearchFunc;
	mySearch = function(source: string, subString: string) {
	  var result = source.search(subString);
	  if (result == -1) {
	    return false;
	  }
	  else {
	    return true;
	  }
	}

对于函数类型的interface，并不需要参数名的对应相同，如下例：

	var mySearch: SearchFunc;
	mySearch = function(src: string, sub: string) {
	  var result = src.search(sub);
	  if (result == -1) {
	    return false;
	  }
	  else {
	    return true;
	  }
	}

对于函数参数的检查，会按照参数的顺序检查对应的类型是否匹配。同时也会检查函数的返回类型是否匹配，在这个函数我们期望返回boolean类型true/false， 如果返回的是numbers或者string，则类型检查系统会提示返回值类型不匹配。

##数组类型

类似于函数类型，TypeScript也可以描述数组类型。在数组类型中有一个'index'类型其描述数组下标的类型，以及返回值类型描述每项的类型，如下：

	interface StringArray {
	  [index: number]: string;
	}

	var myArray: StringArray;
	myArray = ["Bob", "Fred"]

index的支持两种类型，分别是字符串和数值类型. 我们可以限制index的类型，同时也可以检查index项的返回值类型。

index的类型签名可以描述常用的数组或者是‘dictionary’（字典序）模式，这点会强制所有的属性都需要和其返回值匹配。下例中length属性不匹配这点，所以类型检查会给出一个错误：

	interface Dictionary {
	  [index: string]: string;
	  length: number;    // error, the type of 'length' is not a subtype of the indexer
	} 

##Class类型

####实现interface
在C#和java中interface是很常使用的类型系统，其用来强制其实现类符合其契约。在TypeScript中同样也可以实现：

	interface ClockInterface {
	    currentTime: Date;
	}

	class Clock implements ClockInterface  {
	    currentTime: Date;
	    constructor(h: number, m: number) { }
	}

同样也可以在interface中实现函数类型的契约，并要求clas实现此函数。如下例的‘setTime’函数：

	interface ClockInterface {
	    currentTime: Date;
	    setTime(d: Date);
	}

	class Clock implements ClockInterface  {
	    currentTime: Date;
	    setTime(d: Date) {
	        this.currentTime = d;
	    }
	    constructor(h: number, m: number) { }
	}

interface描述的的是class的公开(public)部分，而不是私有部分.

####类static/instance区别

当使用类和接口的时候，我们需要知道类有两种类型：static(静态)部分和instance(实例)部分。如果尝试一个类去实现一个带有构造签名的interface，TypeScript类型检查会提示你错误。

	interface ClockInterface {
	    new (hour: number, minute: number);
	}

	class Clock implements ClockInterface  {
	    currentTime: Date;
	    constructor(h: number, m: number) { }
	}

这是因为一个类去实现接口的时候，只有instance(实例)的部分才会被检查。而构造函数属于静态部分，所以不会被类型检查。

相反你可以直接在类中实现这些(static)静态部分，如下例：

interface ClockStatic {
    new (hour: number, minute: number);
}

class Clock  {
    currentTime: Date;
    constructor(h: number, m: number) { }
}

var cs: ClockStatic = Clock;
var newClock = new cs(7, 30);

####interface的继承

和类一样，接口也能集成其他的接口。这相当于复制接口的所有成员。接口的集成是的我们可以自由的抽象和分离到可重用的组件。

	interface Shape {
	    color: string;
	}

	interface Square extends Shape {
	    sideLength: number;
	}

	var square = <Square>{};
	square.color = "blue";
	square.sideLength = 10;

一个interface可以同时集成多个interface，实现多个接口成员的合并。

	interface Shape {
	    color: string;
	}

	interface PenStroke {
	    penWidth: number;
	}

	interface Square extends Shape, PenStroke {
	    sideLength: number;
	}

	var square = <Square>{};
	square.color = "blue";
	square.sideLength = 10;
	square.penWidth = 5.0;

##混合式类型

如前边提到的一样，在interface几乎可以描述JavaScript世界的一切对象。因为JavaScript是一个动态，灵活的脚本语言，所以偶尔也希望一个对象能够描述一些多个类型.

下面是一个混合式描述函数，对象以及额外属性的实例：

	interface Counter {
	    (start: number): string;
	    interval: number;
	    reset(): void;
	}

	var c: Counter;
	c(10);
	c.reset();
	c.interval = 5.0;

和第三方JavaScript库交互的时候，也许我们也会上面的模式来描述一个完整的类型。
