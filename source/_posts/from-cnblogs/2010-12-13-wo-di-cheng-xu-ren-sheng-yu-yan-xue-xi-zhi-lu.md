---
layout: post
title: "我的程序人生--语言学习之路"
description: "我的程序人生--语言学习之路"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在这里总结一下我在语言学习之路。我是一个信息与计算科学的学习，属于应用数学，走上了程序员之路，回想起觉得有些诧异。我并不是科班出生的合格程序员。我走上这条道理也是一种偶然，或许该说是兴趣所致吧。在大学之前，我一个僻远山区的孩子，计算机这个东西碰都没有碰过得，记得高中会考时候连复制、新建这些简单操作都不知道的我，大学在第一个语言课C学习中感到了乐趣所在，在编写出每一个code，都能让我有一种自豪感。慢慢的我爱上的Code，又等到了两个老师的帮助，进入了某大企业实习。大二开始就在外边做项目，给我了许多程序基础理论和设计思想等方面的积累。使我的程序之路走的比较顺利，毕业时，虽然某些企业对我的经验有所怀疑。

&nbsp;&nbsp;&nbsp; 在大学语言的学习之路我学了好几门语言，在这里和大家一一分享下我的这条学习之路。

&nbsp;&nbsp;&nbsp; 按时间来说我接触的首先是c这门古老的语言，也是他带着我走上了这条程序之路。在刚学完C的时候我一个非科班的师弟（当时大一下期）在校程序大赛中拿的大奖，树立的我软件的梦想，虽然在毕业后有些徘徊，但是在学生期间对我的程序学习之路是很大的鼓励，当时我还学习的C的一些高级编程Socket等（现在已忘的差不多了），还参加了学校的单片机创新课题用C Show了一下，哈哈。下面是我当时的最后综合实验程序-多种排序集合：

     #include<stdio.h> 
            #define M  20

            void disp1(int *a,int n) 
            {    int i; 
            printf("\nsort before  :*****\n"); 
              for(i=1;i<=n;i++) 
                printf(" %3d",a[i]); 
            }

            void disp2(int *a,int n) 
            { int i; 
              printf("\nsort after  :*****\n"); 
            for(i=1;i<=n;i++) 
                 printf(" %3d",a[i]); 
                  a[0]=-1; 
            }

            void create(int *a,int *b,int  *n) 
            {int i; 
              printf("input the toall\n"); 
                 scanf("%d",n); 
                for(i=1;i<=*n;i++) 
                {  printf("input the %d\n",i); 
                    scanf("%d",&a[i]); 
                     b[i]=a[i]; 
                  } 
               a[0]=b[0]=0; 
            }

            void  insertsort(int *a,int n) 
            { int i,j;

              for(i=2;i<=n;i++) 
               {  a[0]=a[i]; 
                 for(j=i-1;a[0]<a[j];j--) 
                            a[j+1]=a[j]; 
                      a[j+1] =a[0]; 
                }

            }


            void xiersort(int *a,int n) 
            { int d[3]={5,3,1}; 
               int i,j,k=0;

               while(k<3) 
            {  for(i=d[k]+1;i<=n;i++) 
                 {   a[0]=a[i]; 
                     for(j=i-d[k];j>0&&a[j]>a[0];j=j-d[k]) 
                            a[j+d[k]]=a[j]; 
                      a[j+d[k]]=a[0]; 
                  } 
                k++; 
            }

            }


            void maopaosort(int *a,int n) 
            {  int i,j,change,t;

              for(i=1;i<n;i++) 
               { change=0; 
                   for(j=1;j<=n-i;j++) 
                      if(a[j]>a[j+1]) 
                          { t=a[j]; 
                             a[j]=a[j+1]; 
                              a[j+1]=t; 
                               change=1; 
                           }

                   if(change==0) 
                               break; 
                  } 
            }


            void quicksort(int *a,int t, int n) 
            {  int i=t,j=n;

              while(i<j) 
            {   if(i<j) 
                {   a[0]=a[i]; 
                     while(i<j&&a[j]>a[0]) 
                                 j--; 
                     if(i<j) 
                       {  a[i]=a[j]; 
                             i++; 
                         }

                   while(i<j&&a[i]<a[0]) 
                                 i++; 
                     if(i<j) 
                       {  a[j]=a[i]; 
                             j--; 
                         } 
                } 
                   a[i]=a[0]; 
                 quicksort(a,1,i-1); 
                 quicksort(a,i+1,n);

            } 
            }


            void jiandansort(int *a,int n) 
            { int i,j,t; 
              for(i=1;i<n;i++) 
              { for(j=i+1;j<=n;j++) 
                   if(a[i]>a[j]) 
                   {  t=a[i]; 
                        a[i]=a[j]; 
                       a[j]=t; 
                    } 
               } 
            }

             

            void main( ) 
            {int a[M+1],b[M+1],n=0,i; 
            char ch1='y',ch2; 
            create(a,b,&n);

            while(ch1=='y'||ch1=='Y') 
            { printf("\n input 1---------  insert sort"); 
               printf("\n input 2---------  xi er sort"); 
               printf("\n input 3---------mao pao sort"); 
               printf("\n input 4---------  quick sort"); 
                printf("\n input 5--------  jian dan sort"); 
                printf("\n inputc(C)---------  creat"); 
                printf("\n input n(N)---------  exit\n");

                scanf("\n%c",&ch2); 
                 if(a[0]==-1) 
                   for(i=1;i<=n;i++) 
                     a[i]=b[i];

            switch(ch2) 
            { case  '1': disp1(a,n);     insertsort(a,n) ; 
                               disp2(a,n);      break; 
               case  '2': disp1(a,n);     xiersort(a,n); 
                                disp2(a,n);    break; 
               case  '3': disp2(a,n);     maopaosort(a,n); 
                               disp2(a,n);       break; 
               case  '4': disp1(a,n);    quicksort(a,1,n); 
                              disp2(a,n);      break; 
                case  '5':disp1(a,n);       jiandansort(a,n); 
                                disp2(a,n);     break; 
                case  'c': 
                case  'C':create(a,b,&n);   break; 
                case  'n': 
                case  'N' :ch1='n'; 
            } 
            } 
            }

 现在看起代码是比较糟糕!
 
&nbsp; 接着我学习的汇编这门更古老的语言的，个人感觉汇编若只是说语法和学习，并不难。在这里也贴出我学习时候的一个打字游戏的小Code.

             
        ;;;;任意掉落字符,按空格和ESC暂停并再ESC结束,空格继续;; 
        .model small 
        clear_screen macro op1,op2,op3,op4 ;清屏宏定义   
        push ax 
        push bx 
        push cx 
        push dx 
            mov ah,06h          
            mov al,00h 
            mov bh,06h 
            mov ch,op1 
            mov cl,op2 
            mov dh,op3 
            mov dl,op4 
            int 10h 
            mov ah,02h 
            mov bh,0h 
            mov dh,00h 
            mov dl,00h 
            int 10h 
        pop dx 
        pop cx 
        pop bx 
        pop ax 
        endm

        set  macro p1,p2,p3 ;;;设置光标并显示p1 
        push cx 
        mov ah,02h 
        mov bh,0h

        mov dx,p3 
        mov dh,p2 
        int 10h 
        mov ah,0ah 
        mov al,p1 
        mov cx,1 
        mov bl,12 
        int 10h 
        pop cx 
        endm

        delay macro;;;拖延时间 
        local sg1,sg2,nextdelay,nextdelay1 
        push cx 
        push dx 
        push  ax 
        mov dx,speed 
        mov cx,1000 
        sg1 : 
        sg2 : 
           loop sg2 
        dec dx 
        jnz sg2 
        mov ah,0bh 
        int 21h 
        cmp al,0h;;无字符可以读取 
        je nextdelay 
        mov ah,7 
        int 21h 
        cmp al,' ' 
        je calll 
        cmp al,1bh 
        jne nextdelay1 
        calll : 
        call justment 
          jmp  nextdelay 
        nextdelay1: 
        cmp al,letters[si] 
          jne  nextdelay 
          call disp 
        nextdelay: 
        pop ax 
        pop dx 
        pop  cx 
        endm

        menu  macro op1,op2,op3 ;菜单显示宏定义      
           mov ah,02h 
           mov bh,00h 
           mov dh,op1 
           mov dl,op2 
           int 10h 
           mov ah,09h 
           lea dx,op3 
           int 21h 
        endm


        .model 
        .stack 256 
        .data 
        letters db "jwmilzoeucgpravskntxhdyqfb" 
                db 'iytpkwnxlsvxrmofzhgaebudjq' 
                db 'nwimzoexrphysfqtvdcgljukdas' 
        count equ $-letters ;;79 
        menu0 db "Welcome to play !$"   
        menu1 db 'input enter to game!',0dh,0ah,'$' 
        menu2 db 'input space to halt!',0dh,0ah,'$' 
        menu3 db 'input esc to exit!',0dh,0ah,'$' 
        menu40 db 'this is agame which pritise keyin,',0dh,0ah,'$' 
        menu41    db ' when you are exit from the ' 
                         db 'game ,you will',0dh,0ah,'$' 
        menu42 db ' kown how much you can hit ',0dh,0ah,'$' 
        msg db 'choise speed:f--fast;s--slow;other character--orditional ! ' 
        msg0 db 'you hit:$' 
        msg1 db 'Help : space--- halt   Esc---home$' 
        speed dw  800 
        h dw ? 
        l  db ? 
        gs db 0 
        .code 
        mov ax,@data 
        mov ds,ax 
        menulist : 
        clear_screen 0d,00d,25d,79d  ;;24*80(0开始) 
        menu 07,20,menu0       ;菜单信息的宏调用 
                 menu 09,20,menu1 
                 menu 11,20,menu2 
                 menu 13,20,menu3 
                 menu 15,20,menu40 
                 menu 17,22,menu41 
                 menu 19,22,menu42 
        again: 
        mov ah,0 
        int 16h 
        cmp al,1bh 
          jne nextmain1 
        jmp overmain 
        nextmain1 : 
        cmp al,0dh 
        jne  again 
        clear_screen 0d,00d,25d,79d  ;;24*80(0开始) 
        call setspeed 
        clear_screen 0d,00d,25d,79d  ;;24*80(0开始) 
        menu 0,5,msg1;;help menu 
        mov dx,0 
        ag0: 
        call outdb 
        call rand 
        mov di,si 
        call rand 
          add di,si 
        shr di,1;;;列坐标 
        mov cx,1 
        call rand 
        push ax 
        mov ax,si 
          call rand 
          add si,ax 
          shr si,1;;;产生字符去两次的平均值 
        pop ax 
        ag : 
        mov h,di 
        mov l,cl 
        mov al,letters[si] 
        set al,cl,di 
          delay 
        dispag : 
        set ' ',cl,di 
          inc cx 
        cmp cx,23 
        je next 
        jmp ag 
        next : 
        inc dx 
        cmp dx,5 
        je  overmain 
        jmp ag0 
        overmain:


        call outdb 
        mov ah,4ch 
        int 21h

        ;;;;;; 
        rand proc 
        push ax 
        push bx 
        push cx 
        push dx 
          
        sti;允许中断1ah:0 
        mov ah,0 
        int 1ah 
        mov ax,dx 
        and  ah,0;;清除高6位 
        mov bl,count 
        div  bl 
        mov al,ah 
        mov ah,0 
        mov si,ax 
        pop dx 
        pop  cx 
        pop bx 
        pop ax 
        ret 
        rand endp 
        ;;;;;;;; 
        justment proc

        cmp al,' ' 
        call stop;;暂停

        ret 
        justment endp 
        ;;;;;;;;;;;;;;; 
        stop proc 
        ;;;;;;;;;;;;;;local agstop 
        agstop : 
        mov ah,0bh 
        int 21h 
        cmp al,0 
        je  agstop 
        mov ah,7 
        int 21h 
        cmp al,' ' 
        je overstop 
        cmp al,1bh 
        jne nextagstop1 
        jmp menulist 
        nextagstop1: 
        jmp agstop 
        overstop: 
        ret 
        stop endp

        ;;;; 
        disp proc 
        set ' ',l,h 
        inc gs 
        call ring

        call outdb 
        jmp ag0 
        ret 
        disp endp 
        ;;;;;;;;;; 
        outdb proc 
        push ax 
        push bx 
          push cx 
        push dx

        mov ah,02h 
           mov bh,0h 
           mov dh,0 
           mov dl,60 
           int 10h

        mov ah,9 
        mov dx,offset msg0 
        int 21h 
        mov al,gs

          mov ch,10 
        mov cl,0;记数 
        mov bh,0;;bh=0 
        agodb : 
          mov ah,0 
          div ch 
          mov bl,ah;;存余数入栈 
           add bl,'0' 
        push bx 
           inc cl 
           cmp al,0 
            jg agodb 
          mov ch,0

        agodb1 : 
        pop bx 
        mov dx,bx 
        mov ah,2 
        int 21h 
        loop agodb1

        ;;mov dl,0dh 
        ;; mov ah,2 
        ;;int 21h 
        ;; mov dl,0ah 
        ;; mov ah,2 
        ;;int 21h

        pop dx 
        pop cx 
        pop bx 
        pop ax 
        ret 
        outdb endp 
        ;;;;;;;;;;;;;; 
        setspeed proc 
        push ax 
        menu 15,5,msg 
        mov  ah,1h 
        int 21h 
        cmp al,'f' 
        je nextspeed1 
        cmp al,'s' 
          jne nextspeed2 
        mov speed,1000 
        jmp  nextspeed2 
        nextspeed1 : 
        mov speed,500 
        nextspeed2: 
        pop ax 
          ret 
        setspeed endp

        ;;;;;;;;;;;;; 
        ring proc 
        push ax 
        push cx 
        push dx

        mov cx,3 
        ringed : 
        mov ah,02h 
        mov dl,07h 
        int 21h 
        clear_screen 1d,00d,25d,79d  ;;24*80(0开始) 
        loop ringed 
        pop dx 
        pop cx 
        pop ax 
        ret 
        ring endp

        end

&nbsp;&nbsp;&nbsp;&nbsp; 紧接着遇见的上面说的两位老师他们用的是c#语言，和他们一起做些小开发，所以我也走上了,NET之路，刚开始做了几个Web的开发。其中一个老师是某企业的架构师，所以在他的帮助和介绍下，我和他一同学习并进入企业实习，做了一些Winform的开发，平时空闲的时候就在老师的指导下位他的快速开发平台，添加一些新东西，改进等工作。那时虽然辛苦一些，但是过的挺充实的，读书的时候还有比较好的外快，挺兴奋的。同时，我也没有拉下一门课程学习，虽然经常不去上课，老师们都挺支持和理解我的，期末时考试也考得很好。在这里我感谢每一位关心和支持我的老师们，你们辛苦了。

&nbsp;&nbsp;&nbsp;&nbsp; 在.NET平台上C#肯定和必备的，在这里也挑不出来典型的code展示，同时在,NET平台的唯一函数式编程语言出来后，我带着多函数式思想的理解的心情，学习了这门语言，第一次感觉到函数式编程的魅力所在，并不是写一些code（博客里贴出了两篇[<font color="#6699cc">F#初试（2）</font>](http://www.cnblogs.com/whitewolf/archive/2010/11/29/1891322.html) 、[<font color="#6699cc">F#初试--打印目录文件树</font>](http://www.cnblogs.com/whitewolf/archive/2010/07/14/1777408.html)）。&nbsp;&nbsp;&nbsp; 

&nbsp;&nbsp;&nbsp; 后来我也学习了我们的面向对象的语言C++，Java，MathLab（对于数学专业的尅定是必须的，呵呵）。在c++学习时候学的感觉挺好的，但是到了准备学习MFC，看着他的函数名称等一大堆的字母，比起C#是难，这是我的c#也学得有一定基础，所以我放弃了。对于Java我还是很指着的学习了一段时间，会Java Bean，model1的开发，但只能说是基础的，当时让我苦恼的是Java一大堆的东西需要自己手工配置，还有就是那个IDE的智能提示速度让人还郁闷.绕了一圈还是继续我的.NET之路，因为在外边我所做的都是基于c# WinForm的开发，它有一个优秀的类库和IDE支持。虽然我没有继续Java，c++的学习，但是我觉得他们也是很优秀的，并不比c#差。对于一个程序不管你是c#，Java编写的能满足客户需求就是一个好的code，程序只是各种语言抒写的艺术，不该存在语言之争。毕业之时我希望走的c的编程，但是没有这样的基于，还有就是.NET已经具有了一定基础，更好找工作些，如果有机会我觉得我还想走c的编程，前提是工资与我.NET持平，呵呵。

&nbsp;&nbsp;&nbsp;&nbsp; 本想写的好些，但是我的文字功底太差了，构思的时候挺多的，一到写的时候感觉痛困难的，需要多多练习。请大家多多指教。

&nbsp;&nbsp;&nbsp;&nbsp; 随笔收尾了，虽然现实与梦想存在差距，但是我的程序之路然在继续&#8230;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2010/12/13/1904361.html "原文首发")