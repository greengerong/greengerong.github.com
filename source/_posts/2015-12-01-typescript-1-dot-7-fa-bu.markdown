---
layout: post
title: "TypeScript 1.7发布"
date: 2015-12-01 20:25:55 +0800
comments: true
categories: [TypeScript, JavaScript]
---

TypeScript1.7在今天发布了，可以在[Visual Studio 2015 Update 1](http://blogs.msdn.com/b/visualstudio/archive/2015/11/30/visual-studio-update-1-rtm.aspx)中开始尝试关于它的新特性了。在这次发布特性中开始启用了对async/await的支持、‘多态’中的this类型、ES6 stage 3的求幂运算符等。

	"use strict";
	// printDelayed is a 'Promise<void>'
	async function printDelayed(elements: string[]) {
	    for (const element of elements) {
	        await delay(200);
	        console.log(element);
	    }
	}
	 
	async function delay(milliseconds: number) {
	    return new Promise<void>(resolve => {
	        setTimeout(resolve, milliseconds);
	    });
	}
	 
	printDelayed(["Hello", "beautiful", "asynchronous", "world"]).then(() => {
	    console.log();
	    console.log("Printed every element!");
	});

