---
layout: post
title: "TypeScript - Modules(模块)"
date: 2015-04-12 16:52:50 +0800
comments: true
categories: [TypeScript, JavaScript]
---
##简介

在TypeScript中提供了module(模块)的方式管理和组织代码结构。这里覆盖了内部和外部的模块，以及在何时怎么使用它。当然也有一些高级话题如何使用外部模块以及如何组织公用模块。

##第一步

让我们从下面的例子开始，这个例子将会贯通本文。首先我们写了一段字符串验证的例子，用来验证用户在web页面form表单输入的信息，或者是外部文件导出的数据信息。

####单文件的验证逻辑

	interface StringValidator {
	    isAcceptable(s: string): boolean;
	}

	var lettersRegexp = /^[A-Za-z]+$/;
	var numberRegexp = /^[0-9]+$/;

	class LettersOnlyValidator implements StringValidator {
	    isAcceptable(s: string) {
	        return lettersRegexp.test(s);
	    }
	}

	class ZipCodeValidator implements StringValidator {
	    isAcceptable(s: string) {
	        return s.length === 5 && numberRegexp.test(s);
	    }
	}

	// Some samples to try
	var strings = ['Hello', '98052', '101'];
	// Validators to use
	var validators: { [s: string]: StringValidator; } = {};
	validators['ZIP code'] = new ZipCodeValidator();
	validators['Letters only'] = new LettersOnlyValidator();
	// Show whether each string passed each validator
	strings.forEach(s => {
	    for (var name in validators) {
	        console.log('"' + s + '" ' + (validators[name].isAcceptable(s) ? ' matches ' : ' does not match ') + name);
	    }
	});

####增加模块化

我们将会增加更多的验证逻辑，并且我们希望有个好的代码组织来避免全部的污染和命名冲突。所以更好的方式是给一个命名空间来	组织我们的对象在一个模块中。

在下面我们将把所有的验证逻辑移到一个叫‘Validation’的模块来组织我们的代码逻辑。因为我们希望interface和class在外部模块可见，所以我们加上了‘export’关键字导出成员。相反lettersRegexp和numberRegexp的逻辑是你不实现，我们并不希望暴露给外部模块。在文件最后的测试代码是放在外部模块，例如Validation.LettersOnlyValidator之类的。

####模块化的Validators

	module Validation {
	    export interface StringValidator {
	        isAcceptable(s: string): boolean;
	    }

	    var lettersRegexp = /^[A-Za-z]+$/;
	    var numberRegexp = /^[0-9]+$/;

	    export class LettersOnlyValidator implements StringValidator {
	        isAcceptable(s: string) {
	            return lettersRegexp.test(s);
	        }
	    }

	    export class ZipCodeValidator implements StringValidator {
	        isAcceptable(s: string) {
	            return s.length === 5 && numberRegexp.test(s);
	        }
	    }
	}

	// Some samples to try
	var strings = ['Hello', '98052', '101'];
	// Validators to use
	var validators: { [s: string]: Validation.StringValidator; } = {};
	validators['ZIP code'] = new Validation.ZipCodeValidator();
	validators['Letters only'] = new Validation.LettersOnlyValidator();
	// Show whether each string passed each validator
	strings.forEach(s => {
	    for (var name in validators) {
	        console.log('"' + s + '" ' + (validators[name].isAcceptable(s) ? ' matches ' : ' does not match ') + name);
	    }
	});

##分离模块文件

随之项目代码的增加，我们希望能够分离文件，让项目更好的维护和开发。

在下面我们将分离我们的验证逻辑为多个文件。虽然分离在多个文件，但是我们仍然可以共享一个命名空间，因为需要告诉编译器文件之间的关系，所以我在文件开始加入了reference tags得标记。再对于我们的测试代码没有什么改变。

####多文件的内部模块

######Validation.ts

	module Validation {
	    export interface StringValidator {
	        isAcceptable(s: string): boolean;
	    }
	}

######LettersOnlyValidator.ts

	/// <reference path="Validation.ts" />
	module Validation {
	    var lettersRegexp = /^[A-Za-z]+$/;
	    export class LettersOnlyValidator implements StringValidator {
	        isAcceptable(s: string) {
	            return lettersRegexp.test(s);
	        }
	    }
	}

######ZipCodeValidator.ts

	/// <reference path="Validation.ts" />
	module Validation {
	    var numberRegexp = /^[0-9]+$/;
	    export class ZipCodeValidator implements StringValidator {
	        isAcceptable(s: string) {
	            return s.length === 5 && numberRegexp.test(s);
	        }
	    }
	}

######Test.ts

	/// <reference path="Validation.ts" />
	/// <reference path="LettersOnlyValidator.ts" />
	/// <reference path="ZipCodeValidator.ts" />

	// Some samples to try
	var strings = ['Hello', '98052', '101'];
	// Validators to use
	var validators: { [s: string]: Validation.StringValidator; } = {};
	validators['ZIP code'] = new Validation.ZipCodeValidator();
	validators['Letters only'] = new Validation.LettersOnlyValidator();
	// Show whether each string passed each validator
	strings.forEach(s => {
	    for (var name in validators) {
	        console.log('"' + s + '" ' + (validators[name].isAcceptable(s) ? ' matches ' : ' does not match ') + name);
	    }
	});

如果存在多文件的依赖，我们需要保证编译器能加载各个文件。这里有两种方式做到：

第一种方式：可以利用 --out 连接多个输入文件让编译器编译成一个单一js文件（{{ tsc --out sample.js Test.ts }}）。这样编译器会自动根据 reference tags 自动组织多个文件编译成一个js文件。我们也可以组织个别的文件如：{{ tsc --out sample.js Validation.ts LettersOnlyValidator.ts ZipCodeValidator.ts Test.ts }}。

第二种方式：我们也可以采用预先文件的编辑来加载多个文件，我们可以使用script tag在web页面加载来控制文件顺序，例如：

#######MyTestPage.html (excerpt)

 	<script src="Validation.js" type="text/javascript" />
    <script src="LettersOnlyValidator.js" type="text/javascript" />
    <script src="ZipCodeValidator.js" type="text/javascript" />
    <script src="Test.js" type="text/javascript" />

