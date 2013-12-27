---
layout: post
title: "利用Node.js为Node.js生成HttpStatusCode辅助类并发布到npm"
description: "利用Node.js为Node.js生成HttpStatusCode辅助类并发布到npm"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 作为一个好的Restfull Api不仅在于service url的语义,可读性,幂等,正交，作为http状态码也很重要，一个好的Http Status Code给使用者一个很好的响应，比如200表示正常成功，201表示创建成功，409冲突，404资源不存在等等。所以在做一个基于node.js+mongodb+angularjs的demo时发现node.js express没有提供相应的辅助类，但是本人不喜欢将201,404这类毫无语言层次语义的东西到处充斥着，所以最后决定自己写一个，但是同时本人也很懒，不喜欢做重复的苦力活，怎么办？那就从我最熟悉的c#中HttpStatusCode枚举中copy出来吧，最后为了简便在mac上所以采用了利用node.js去解析msdn关于httpstatuscode的文档生成node.js的辅助类。

&nbsp;&nbsp;&nbsp; 代码很简单：

         var http = require('http');

        var fs = require('fs');

        var $ = require('jquery');

        var output = "httpStatusCode/index.js";

        (function(){

            

            String.format = function() {

                var s = arguments[0];

                for (var i = 0; i < arguments.length - 1; i++) {

                    var reg = new RegExp("\\{" + i + "\\}", "gm");

                    s = s.replace(reg, arguments[i + 1]);

                }

                return s;

            };




            var options = {

                host:'msdn.microsoft.com',

                port:80,

                path:'/zh-cn/library/system.net.httpstatuscode.aspx'

            };




            http.get(options,function (response) {

                var html = "";

                response.on("data",function (chunk) {

                    html += chunk;

                }).on("end", function () {

                    handler(html);

                }).on('error', function (e) {

                    console.log("Got error: " + e.message);

                });




            function getHttpStatusCode(htmlString) {

                var $doc = $(html);

                var rows = $doc.find("table#memberList tr:gt(0)");

                var status = {};

                rows.each(function(i,row){

                    status[$(row).find("td:eq(1)").text()] = 

                        parseInt($(row).find("td:eq(2)").text().match(/\d+/).toString());

                });

               return status;

            };

             

            function generateCode(status){

               var code = "";

               code += "exports.httpStatusCode = " + JSON.stringify(status) + ";";

               return code;

            };

            

            function writeFile(code){

                fs.writeFile(output, code, function(err) {

                    if(err) {

                        console.log(err);

                    } else {

                        console.log("The file was saved " + output + "!");

                    }

                }); 

            };




            function handler(html){

               var status = getHttpStatusCode(html);

               var code = generateCode(status);

               writeFile(code);

            };




          });

        })();

代码寄宿在github：[https://github.com/greengerong/node-httpstatuscode](https://github.com/greengerong/node-httpstatuscode "https://github.com/greengerong/node-httpstatuscode")

最终生成类为：

         exports.httpStatusCode = { 
            "Continue": 100, 
            "SwitchingProtocols": 101, 
            "OK": 200, 
            "Created": 201, 
            "Accepted": 202, 
            "NonAuthoritativeInformation": 203, 
            "NoContent": 204, 
            "ResetContent": 205, 
            "PartialContent": 206, 
            "MultipleChoices": 300, 
            "Ambiguous": 300, 
            "MovedPermanently": 301, 
            "Moved": 301, 
            "Found": 302, 
            "Redirect": 302, 
            "SeeOther": 303, 
            "RedirectMethod": 303, 
            "NotModified": 304, 
            "UseProxy": 305, 
            "Unused": 306, 
            "TemporaryRedirect": 307, 
            "RedirectKeepVerb": 307, 
            "BadRequest": 400, 
            "Unauthorized": 401, 
            "PaymentRequired": 402, 
            "Forbidden": 403, 
            "NotFound": 404, 
            "MethodNotAllowed": 405, 
            "NotAcceptable": 406, 
            "ProxyAuthenticationRequired": 407, 
            "RequestTimeout": 408, 
            "Conflict": 409, 
            "Gone": 410, 
            "LengthRequired": 411, 
            "PreconditionFailed": 412, 
            "RequestEntityTooLarge": 413, 
            "RequestUriTooLong": 414, 
            "UnsupportedMediaType": 415, 
            "RequestedRangeNotSatisfiable": 416, 
            "ExpectationFailed": 417, 
            "UpgradeRequired": 426, 
            "InternalServerError": 500, 
            "NotImplemented": 501, 
            "BadGateway": 502, 
            "ServiceUnavailable": 503, 
            "GatewayTimeout": 504, 
            "HttpVersionNotSupported": 505 
        };

&nbsp;&nbsp;&nbsp; 最后考虑到或许还有很多像我一样懒散的人，所以共享此代码发布到了npm，只需要npm install httpstatuscode，便可以简单实用，如下是一个测试demo：

          var httpStatusCode = require("httpstatuscode").httpStatusCode;

        var toBeEqual = function (actual,expected){

            if(actual !== expected){

             throw (actual + " not equal " + expected);

            }

        };

        toBeEqual(httpStatusCode.OK,200);

        toBeEqual(httpStatusCode.Created,201);

        toBeEqual(httpStatusCode.BadRequest,400);

        toBeEqual(httpStatusCode.InternalServerError,500);




        console.log(httpStatusCode);

        console.log("success");

&nbsp;&nbsp;&nbsp; 懒人的文章总是代码多余文字，希望代码能说明一切，感谢各位能阅读此随笔。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/04/09/3009205.html "原文首发")