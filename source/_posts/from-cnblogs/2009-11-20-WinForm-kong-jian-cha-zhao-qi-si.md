---
layout: post
title: "WinForm控件查找奇思"
description: "WinForm控件查找奇思"
category: cnblogs
tags: [code,cnblogs]
---
最近做WinForm程序，尽搞些动态生成控件的，每次寻找某个空间时总要一大堆代码，简单但是写的多，烦啊。突然想起了Linq里的表达式方式，但是项目用的类库是2.0的。最后仿照Linq用范型写了一个遍历类:减少了一大堆不必要的代码。
代码很简单，就不用解释了，直接贴↑。

代码很简单，就不用解释了，直接贴&#8593;。

        public delegate bool SearchHandler(Control ctrFind);
            public class WinSearch<T>
            {
        //ctr：查找起点控件。
                public static T Search(Control ctr, SearchHandler handler)
                {
                    if (handler == null)
                        throw new Exception("Handler must be not null");
                    if (ctr == null)
                        throw new Exception("Parent Control must be not null");
                    if (!(ctr is Control))
                        throw new Exception("The fist parameter must be innert from Control");
                    return SearchProxy(ctr, handler);
                }

                protected static T SearchProxy(Control ctr,SearchHandler handler)
                {
                    if (ctr.Controls.Count < 1)
                    {
                        return default(T);
                    }
                    else
                    {
                        foreach (Control child in ctr.Controls)
                        {
                            if (child is T  && handler(child))//注意返回范型类型应是如此才会返回。
                            {
                                return (T)(object)child;
                            }
                            else
                            {
                                foreach (Control ch in child.Controls)
                                {
                                    object obj = SearchProxy(ch, handler);
                                    if (obj !=null)
                                    {
                                        return (T)obj;
                                    }
                                }
                            }
                        }
                        return default(T);
                    }
                }
               
                    
            }
            
            
 测试代码：
 
 
        private void button1_Click(object sender, EventArgs e)
                {
                    Button btn = WinSearch<Button>
                    .Search(this, new SearchHandler(mehtod));
                    if (btn != null)
                    {
                        MessageBox.Show(btn.Text);
                    }
                }
                public bool mehtod(Control ctr)
                {
                    if (ctr.Text =="button2")
                        return true;
                    return false;
                }
                
 
本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/11/20/1606587.html "原文首发")