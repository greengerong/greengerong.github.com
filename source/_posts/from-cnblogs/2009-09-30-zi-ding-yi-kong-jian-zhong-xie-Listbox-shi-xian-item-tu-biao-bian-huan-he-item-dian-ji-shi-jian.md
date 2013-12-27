---
layout: post
title: "自定义控件---重写Listbox实现item图标变换和item点击事件"
description: "自定义控件---重写Listbox实现item图标变换和item点击事件"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;博客开通有一阵了，就是没有时间写，遗憾啊。！
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这几天做了个排序的自定义控件，在listbox item里放是button 并支持图标的交替变换
效果如下： 博客开通有一阵了，就是没有时间写，遗憾啊。！
      这几天做了个排序的自定义控件，在listbox item里放是button 并支持图标的交替变换
效果如下：
![](http://images.cnblogs.com/cnblogs_com/whitewolf/order.jpeg)

把代码贴上：
		
		  1using System;
		  2using System.Collections.Generic;
		  3using System.Collections;
		  4using System.Text;
		  5using System.ComponentModel;
		  6using System.Windows.Forms;
		  7using System.Drawing;
		  8using System.Drawing.Text;
		  9using System.Data;
		 10
		 11namespace SQLAnalysis
		 12{
		 13    public class ListBoxEx : ListBox
		 14    {
		 15        public ListBoxEx()
		 16        {
		 17            this.DrawMode = DrawMode.OwnerDrawFixed;
		 18            btnList = new List<Button>();
		 19        }
		 20        public override DrawMode DrawMode
		 21        {
		 22            get
		 23            {
		 24                return DrawMode.OwnerDrawFixed;
		 25            }
		 26            set
		 27            {
		 28                base.DrawMode = DrawMode.OwnerDrawFixed;
		 29            }
		 30        }
		 31       
		 32        protected override void OnResize(EventArgs e)
		 33        {
		 34            base.OnResize(e);
		 35            this.Refresh();
		 36        }
		 37
		 38
		 39
		 40
		 41        public Button FindItemButton(int index)
		 42        {
		 43            
		 44        // return this.Controls.Find(this.Name + "$ItemComboBox" + index.ToString(), true)[0];
		 45            if (index >= btnList.Count)
		 46                return null;
		 47            return btnList[index];
		 48           
		 49        }
		 50
		 51        /// <summary>
		 52        /// 提供删除item项
		 53        /// </summary>
		 54        /// <param name="index"></param>
		 55        public void RemoveItem(int index)
		 56        {
		 57            this.Items.RemoveAt(index);
		 58            btnList[index].Parent = null;
		 59            btnList[index] = null;
		 60            //btnList[index].Dispose();
		 61            
		 62            btnList.RemoveAt(index);
		 63            this.Refresh();
		 64        }
		 65        /// <summary>
		 66        /// 提供移动item项
		 67        /// </summary>
		 68        /// <param name="offset"></param>
		 69        public void MoveItem(int offset)
		 70        {
		 71            
		 72            int index = this.SelectedIndex + offset;
		 73            if (index > -1 && index < this.Items.Count)
		 74            {
		 75                int oldSelectedIndex = this.SelectedIndex;
		 76                Object item = this.SelectedItem;
		 77                this.Items.RemoveAt(oldSelectedIndex);
		 78                this.Items.Insert(index, item);
		 79                Button btn = btnList[oldSelectedIndex];
		 80                btnList.RemoveAt(oldSelectedIndex);
		 81                btnList.Insert(index, btn);
		 82
		 83                this.Refresh();
		 84            }
		 85            else
		 86            {
		 87                MessageBox.Show("不是可用的移动矢量");
		 88
		 89            }
		 90
		 91        }
		 92
		 93        private ToggleItem GetNexttoggleItem(ToggleItem tog)
		 94        {
		 95            int index = -1;
		 96            for (int i = 0; i < ToggleItemList.Count; i++)
		 97            {
		 98                ToggleItem item =(ToggleItem)ToggleItemList[i];
		 99                if (item.Tag == tog.Tag)
		100                {
		101                    index = i;
		102                    break;
		103                }
		104            }
		105            return ((ToggleItem)ToggleItemList[(index + 1) % ToggleItemList.Count]);
		106        }
		107        private List<ToggleItem> toggleItemList ;//List<ToggleItem> toggleItemList = new List<ToggleItem>();
		108        [Bindable(false), Browsable(false)]
		109        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]   
		110        public List<ToggleItem> ToggleItemList
		111        {
		112            get
		113            {
		114                if (toggleItemList == null)
		115                    toggleItemList = new List<ToggleItem>();
		116                return toggleItemList;
		117            }
		118
		119            set
		120            {
		121                if (toggleItemList == null)
		122                    toggleItemList = new List<ToggleItem>();
		123                toggleItemList = value;
		124            }
		125        }
		126
		127        //主要重写事件
		128        protected override void OnDrawItem(DrawItemEventArgs e)
		129        {
		130            this.DrawMode = DrawMode.OwnerDrawFixed;
		131            this.ItemHeight = 22;
		132            e.DrawBackground();
		133            e.DrawFocusRectangle();
		134            Brush myBrush = Brushes.Black;
		135            if (e.Index > -1 && e.Index < this.Items.Count)
		136            {
		137                string drawString = (e.Index + 1)+ " " + this.Items[e.Index].ToString();
		138                
		139
		140                e.Graphics.DrawString(drawString, e.Font, new SolidBrush(e.ForeColor), e.Bounds, 
		141
		142StringFormat.GenericDefault);
		143                AddButtonToItem(e);
		144            }
		145            base.OnDrawItem(e);
		146
		147        }
		148
		149        private List<Button> btnList = null;
		150        protected void AddButtonToItem(DrawItemEventArgs e)
		151        {
		152            if (btnList.Count <= e.Index)
		153            {
		154                btnList.Add(new Button());
		155                Button btn = btnList[e.Index];
		156                btn.BackColor = System.Drawing.Color.LightSkyBlue ;
		157                btn.Name = this.Name + "$ItemButton" + e.Index.ToString();
		158                btn.Width = 20;
		159                btn.Height = 20;
		160                btn.ImageAlign = ContentAlignment.MiddleCenter;
		161                btn.TextImageRelation = TextImageRelation.ImageAboveText;
		162                if (toggleItemList.Count > 0)
		163                {
		164                    
		165                    btn.BackgroundImage = ((ToggleItem)toggleItemList[0]).BGImage;
		166                    //btn.Width = toggleItemList[0].BGImage.Width;
		167                    //btn.Height = toggleItemList[0].BGImage.Height;
		168                    btn.Tag = ((ToggleItem)toggleItemList[0]).Tag;
		169                }
		170                btn.Parent = this;
		171                btn.Click += new EventHandler(ItemButtonClickHandler);
		172            }
		173            Button bt = btnList[e.Index];
		174            bt.Left = this.Width - bt.Width - 20;
		175            bt.Top = e.Bounds.Top;
		176           
		177        }
		178        /// <summary>
		179        /// item button双击事件；
		180        /// </summary>
		181        /// <param name="sender"></param>
		182        /// <param name="e"></param>
		183        protected void ItemButtonClickHandler(object sender, EventArgs e)
		184        {
		185            int index = -1;
		186            if (sender is Button)
		187                index = this.IndexFromPoint(((Button)sender).Location);
		188
		189            if (index == -1)
		190                return;
		191
		192            Button btn = sender as Button;
		193            ToggleItem togold = new ToggleItem((string)btn.Tag, btn.BackgroundImage);
		194            ToggleItem tognew = this.GetNexttoggleItem(togold);
		195            //btn.Width = tognew.BGImage.Width;
		196            //btn.Height = tognew.BGImage.Height;
		197            btn.BackgroundImage = tognew.BGImage;
		198           
		199            btn.Tag = tognew.Tag;
		200
		201            ItemEventHandler handler = (ItemEventHandler)Events[ItemLabelClickObj];
		202            if (handler != null)
		203            {   
		204                
		205                handler(sender, new ItemButtonClickEventArgs(index)); ;
		206            }
		207        }
		208
		209       
		210
		211        
		243    }
		244    [Serializable]
		245    public class ToggleItem
		246    {
		247        private string tag;
		248        private Image bgImage;
		249        public ToggleItem()
		250        {
		251        }
		252        public ToggleItem(string tag, Image bg)
		253       {
		254           this.tag = tag;
		255           this.bgImage = bg;
		256       }
		257       public string Tag
		258       {
		259            get
		260            {
		261                return tag;
		262           }
		263           set
		264           {
		265                tag = value;
		266            }
		267        }
		268
		269      public Image BGImage
		270        {
		271           get
		272           {
		273               return bgImage;
		274           }
		275
		276           set
		277           {
		278               bgImage = value;
		279
		280           }
		281       }
		282
		283    }
		284
		285}	
		

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2009/09/30/1577101.html "原文首发")