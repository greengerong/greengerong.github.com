---
layout: post
title: "Javascript覆盖率(jstd)报表解析Maven插件"
description: "Javascript覆盖率(jstd)报表解析Maven插件"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp;&nbsp;&nbsp; 最近项目中希望加入javascript覆盖率统计，由于项目的单元测试用的google的jstd（[javascript test driver](http://code.google.com/p/js-test-driver/wiki/CodeCoverage)），jstd生成&lt;config filename&gt;-coverage.dat LCOV 格式，这是一种linux上格式，在window上网上搜寻了很久没找到可用的maven组件。最后狠下心来自己写一个。代码已经放在[github](https://github.com/greengerong/JsTestDriverCoverageReport/tree/zip-resource/sample/green.jstdcoveragereport.test/build)上，并且maven插件也成功[release到官网](https://oss.sonatype.org/index.html#nexus-search;quick~com.github.greengerong)。

coverage 文件格式：

&nbsp;&nbsp;&nbsp; 项目主要采用java将coverage文件解析成java object在利用json序列化输出到固定位置的javascript文件。在利用angularjs显示文件覆盖率报表，利用bootstrap样式展示。

如果你对代码感兴趣，可以参考[github](https://github.com/greengerong/JsTestDriverCoverageReport/tree/zip-resource/sample/green.jstdcoveragereport.test/build)源码，实例也在项目sample下。

使用基本配置：

<div class="cnblogs_Highlighter">
<pre class="brush:html;gutter:false;">            &lt;plugin&gt;

                &lt;groupId&gt;com.github.greengerong&lt;/groupId&gt;

                &lt;artifactId&gt;JSCoverageReport&lt;/artifactId&gt;

                &lt;version&gt;1.0&lt;/version&gt;

                &lt;configuration&gt;

                    &lt;outputDirectory&gt;${basedir}/build/&lt;/outputDirectory&gt;

                    &lt;coverageFile&gt;${basedir}/build/jstd-coverage.dat&lt;/coverageFile&gt;

                    &lt;limit&gt;60&lt;/limit&gt;

                &lt;/configuration&gt;

                &lt;executions&gt;

                    &lt;execution&gt;

                        &lt;phase&gt;test&lt;/phase&gt;

                        &lt;goals&gt;

                            &lt;goal&gt;test&lt;/goal&gt;

                        &lt;/goals&gt;

                    &lt;/execution&gt;

                &lt;/executions&gt;

            &lt;/plugin&gt;
</pre>
</div>

&nbsp;

效果：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201189101.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201174217.png)

&nbsp;

文件执行明细：

[![image](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201202774.png "image")](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201198380.png)

> 代码行之间的样式有点过于大，还没来得及修改样式，敬请原谅。
> 有什么问题请及时在github上提出，希望多多交流。同时也可以作为一个angularjs和bootstrap的例子学习[![LY6DR3ISJE0)6K)L)]~VIZK](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201204136.gif "LY6DR3ISJE0)6K)L)]~VIZK")](http://images.cnblogs.com/cnblogs_com/whitewolf/201212/201212162201205249.gif)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2012/12/16/2820949.html "原文首发")