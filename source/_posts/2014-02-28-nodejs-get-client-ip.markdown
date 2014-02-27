---
layout: post
title: "nodejs获取客户端IP Address"
date: 2014-02-28 00:27:22 +0800
comments: true
categories: [nodejs]
---
在网上看见很多问node.js如何获取客户端IP,所以记录下来，以供大家参考。


        function getClientIp(req) {
            return req.headers['x-forwarded-for'] ||
            req.connection.remoteAddress ||
            req.socket.remoteAddress ||
            req.connection.socket.remoteAddress;
        };

代码，第一段判断是否有反向代理IP(头信息：x-forwarded-for)，在判断connection的远程IP，以及后端的socket的IP。

