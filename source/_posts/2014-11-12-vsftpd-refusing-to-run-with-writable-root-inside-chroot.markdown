---
layout: post
title: "vsftpd refusing to run with writable root inside chroot"
date: 2014-11-12 19:38:05 +0800
comments: true
categories: [vsftpd]
---

![vsftpd](/images/blog_img/vsftpd.jpg)

今天记录一个在安装vsftpd的时候遇见错误：

	500 OOPS: vsftpd: refusing to run with writable root inside chroot ()

在一阵的外文查找，最后定为到是因为用户的根目录可写，并且使用了chroot限制，而这在最近的更新里是不被允许的。要修复这个错误，可以用命令chmod a-w /home/$user去除用户根目录的写权限,或者在vsftpd。conf配置允许writeable。

设置允许writeable为：

	allow_writeable_chroot=YES

最简单的方式就是允许writeable。