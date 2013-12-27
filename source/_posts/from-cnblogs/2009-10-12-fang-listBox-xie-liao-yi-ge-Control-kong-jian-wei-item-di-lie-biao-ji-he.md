---
layout: post
title: "仿listBox写了一个Control控件为item的列表集合"
description: "仿listBox写了一个Control控件为item的列表集合"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp; 仿listBox写了一个Control控件为item的列表集合，由于最近做个项目要用，微软提供的控件实现起来不行，但自己写了一个，效果如下：
![](http://images.cnblogs.com/cnblogs_com/whitewolf/MyItemControlList.jpg)

          using System;
          using System.Collections.Generic;
          using System.ComponentModel;
          using System.Data;
          using System.Drawing;
          using System.Text;
          using System.Text.RegularExpressions;
          using System.Windows.Forms;
          
         namespace SQLAnalysis
         {
           public class MySelfControlList : Control
           {
               private System.Windows.Forms.ErrorProvider err;
               public MySelfControlList()
               {
                   InitializeComponent();
                   this.BackColor = Color.White;
                   itemList = new ListItemColloction();  
                   if (isNeedVaidate)
                   {
                       err = new ErrorProvider();
                   }
               }
              
                 
              
               [Browsable(false)]
               public bool IsValidated
               {
                   get
                   {
                       return List_Validating(); 
                   }
               }
               [DefaultValue(typeof(Color), "White")]
               public override Color BackColor
               {
                   get
                   {
                       return base.BackColor; 
                   }
                   set
                   {
                       base.BackColor = value;
                   }
               }
               private ListItemColloction itemList;
               
              /**//// <summary>
              /// 不提供设计时绑定
              /// </summary>
               [Bindable(false), Browsable(false)]
               [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
               public ListItemColloction Items
               {
                   get
                   {
                       if (itemList == null)
                           itemList = new ListItemColloction();
                       return itemList;
                   }
                   set
                   {
                       itemList = value;
                   }
               }
               public int Count
               {
                   get
                   {
                       return itemList.Count;
                   }
               }
               public void RemoveAll()
               {
                   for( int i=this.itemList.Count -;i>-;i--)
                   {
                       Item item = itemList[i];
                       item.ItemControl.Parent = null;
                       itemList.Remove(item);
                   }
                   
               }
               public int AddItem(Item item)
               {
                   itemList.Add(item);
                   this.Refresh();
                   return itemList.IndexOf(item);
               }
               public void InsertItem(int index, Item item)
               {
                   itemList.Insert(index, item);
                   this.Refresh();
                 }
               public void RemoveItem(Item item)
               {
                   item.ItemControl.Parent = null;
                   itemList.Remove(item);
                   this.Refresh();
               }
               public void RemoveItemAt(int index)
               {
                   itemList[index].ItemControl.Parent = null;
                   itemList.RemoveAt(index);
                   this.Refresh();
               }
               private string emptyText;
               public string EmptyText
               {
                   get
                   {
                    return emptyText;
                   }
                   set
                   {
                    emptyText =value;
                   }
               }
               [Browsable(false)]
               public override string Text
               {
                   get
                   {
                       return base.Text;
                   }
                   set
                   {
                       base.Text = value;
                   }
               }
               
                public string ItemText(int index)
               {
                   return itemList[index].ItemControl.Text;
               }
                private ToolTip toolTip;
               private int itemHeight = ;
               public int ItemHeight
               {
                   get
                   {
                       return itemHeight;
                   }
                    set
                   {
                       itemHeight = value;
                   }
               }
               /**//// <summary>
               /// 重写Paint方法
               /// </summary>
               /// <param name="e"></param>
               protected override void OnPaint(PaintEventArgs e)
               {
                    this.Height = this.itemHeight * (itemList.Count + );
                   base.OnPaint(e);
                   if (itemList.Count == )
                   {
                       e.Graphics.DrawString(this.emptyText, this.Font,Brushes.Black, e.ClipRectangle);
                       return;
                   }
                   
                  
                   //e.Graphics.DrawRectangle(new Pen(Brushes.Black),this.Left,this.Top,this.Width,this.Height);
                   for (int i = ; i < itemList.Count; i++)
                   {
                       Point location = new Point(, i * this.itemHeight);
                       Rectangle bound = new Rectangle(location, new Size(this.Size.Width, this.itemHeight));
                       OnDrawItem(new DrawItemEventArgsMySelf(bound, i, e.Graphics));
                   }
               }
               /**//// <summary>
               /// 画每一项
               /// </summary>
               /// <param name="e"></param>
               protected void OnDrawItem(DrawItemEventArgsMySelf e)
               {
                   Graphics g = e.Graphics;
                   Pen pen = new Pen(Brushes.Wheat);
                   g.DrawRectangle(pen, e.Bound);
                    int index = e.Index;
                   if (index > - && index < itemList.Count)
                   {
                       Control ctr = itemList[index].ItemControl;
                       if (ctr.Parent == null)
                       {
                           ctr.Parent = this;
                       
                           ctr.Height = e.Bound.Height;
                          if( ctr.Width >this.Width)
                            ctr.Width = this.Width - ;
                           toolTip.SetToolTip(ctr, itemList[index].ItemDescribe);
                       }
                       ctr.Location = e.Bound.Location;
                    }
               }
                public bool List_Validating()
               {  bool isValidated = true;
                   foreach (Item item in itemList)
                   {
                       isValidated = isValidated && ListItemControls_Validating(item.ItemControl, new CancelEventArgs());
                   }
                   return isValidated;
               }
                public bool ListItemControls_Validating(object sender, CancelEventArgs e)
               {
                   Control ctr = sender as Control;
                   Item item = itemList[ctr];
                   
                   if (string.IsNullOrEmpty(item.Regex))
                       return true;
                   Regex regex = new Regex(item.Regex);
                    string text = ctr.Text.Trim();
                   if (!regex.IsMatch(text))
                   {
                       err.SetIconAlignment(ctr, ErrorIconAlignment.MiddleRight);
                       err.SetIconPadding(ctr, );
                       err.SetError(ctr, item.ErrorMessage);
                       return false;
                   }
                   err.Clear();
                  
                   return true;
               }
               private void InitializeComponent()
               {
                    this.components = new System.ComponentModel.Container();
                   this.toolTip = new System.Windows.Forms.ToolTip(this.components);
                   this.SuspendLayout();
                   this.ResumeLayout(false);
                }
                private IContainer components;
           }
            public class ListItemColloction : List<Item>
           {
               public Item this[Control itemControl]
               {
                   get
                   {
                       for (int i = ; i < this.Count; i++)
                       {
                           if (this[i].ItemControl.Equals(itemControl))
                               return this[i];
                       }
                       return null;
                   }
                    set
                   {
                       for (int i = ; i < this.Count; i++)
                       {
                           if (this[i].ItemControl.Equals(itemControl))
                               this[i] = value;
                       }
                   }
               }
           }
            [Serializable]
           public class Item
           {
               private Control itemControl = null;
               private string itemDescible = string.Empty;
               private string regex = string.Empty;
               private string errorMessage = string.Empty;
               public Item()
               {
               }
                public Item(Control itemControl, string itemDescible,string regex,string errorMessage)
               {
                   this.itemControl = itemControl;
                   this.itemDescible = itemDescible;
                   this.regex = regex;
                   this.errorMessage = errorMessage;
               }
               public Item(Control itemControl, string itemDescible)
               {
                   this.itemControl = itemControl;
                   this.itemDescible = itemDescible;
                  
               }
               public string Regex
               {
                   get
                   {
                       return regex;
                   }
                   set
                   {
                       regex = value;
                   }
               }
               public Control ItemControl
               {
                   get
                   {
                       return itemControl;
                   }
                   set
                   {
                       itemControl = value;
                   }
               }
                public string ItemDescribe
               {
                   get
                   {
                       return itemDescible;
                   }
                    set
                   {
                       itemDescible = value;
                   }
               }
                public string ErrorMessage
               {
                   get
                   {
                       return errorMessage;
                   }
                   set
                   {
                       errorMessage = value;
                   }
               }
            }
           public class DrawItemEventArgsMySelf : EventArgs
           {
               private Rectangle bound = Rectangle.Empty;
                private int index;
               private Graphics graphics;
               public Graphics Graphics
               {
                   get
                   {
                       return this.graphics;
                   }
               }
               public DrawItemEventArgsMySelf(Rectangle bound, int index, Graphics g)
               {
                   this.bound = bound;
                    this.index = index;
                   this.graphics = g;
               }
               public Rectangle Bound
               {
                   get
                   {
                       return this.bound;
                   }
               }
        
               public int Index
               {
                   get
                   {
                       return index;
                   }
               }
              
           }
        }
        

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/10/12/1581928.html "原文首发")