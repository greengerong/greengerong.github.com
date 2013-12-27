---
layout: post
title: "分享一段PowerShell用户认证Function"
description: "分享一段PowerShell用户认证Function"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在最近工作中遇到对用户验证，需要根据用户名和密码验证用户是否合法。在外文网站找到的这段代码，在这里分享给大家，如果你也需要用户验证的话，那么可以直接copy使用，现在没地方用，也可以收藏备用。

	Function Test-UserCredential {

     	[CmdletBinding()] [OutputType([System.Boolean])]

     	param(

         [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]

         [System.String] $Username,




         [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]

         [System.String] $Password,

        

         [Parameter()]

         [Switch] $Domain

     )

    

     Begin {

         $assembly = [system.reflection.assembly]::LoadWithPartialName('System.DirectoryServices.AccountManagement')

     }

    

     Process {

         try {

             $system = Get-WmiObject -Class Win32_ComputerSystem

             if ($Domain) {

                 if (0, 2 -contains $system.DomainRole) {

                     throw 'This computer is not a member of a domain.'

                 } else {

                     $principalContext = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext 'Domain', $system.Domain

                 }

             } else {

                 $principalContext = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext 'Machine', $env:COMPUTERNAME

             }

            

             return $principalContext.ValidateCredentials($Username, $Password)

         }

         catch {

             throw 'Failed to test user credentials. The error was: "{0}".' -f $_

         }

     }

}

使用很简单方便：Test-UserCredential&nbsp; &#8220;用户名&#8221; &#8220;密码&#8221; &#8220;用户域&#8221;,第三个参数&#8220;用户域&#8221;为可选参数,返回为布尔类型。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/06/09/2543584.html "原文首发")