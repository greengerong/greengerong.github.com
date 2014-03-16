---
layout: post
title: "Intellij修改archetype plugin配置"
date: 2014-03-16 10:51:08 +1100
comments: true
categories: [intellij,archetype]
---
Maven archetype plugin为我们提供了方便的创建
project功能,Archtype指我们项目的骨架，作为项目的脚手架。
如fornt end的yo之类。我们能够通过简单的一行控制台command
line创建你所需要的项目结构：


    mvn archetype:generate
      -DarchetypeGroupId=<archetype-groupId>
      -DarchetypeArtifactId=<archetype-artifactId>
      -DarchetypeVersion=<archetype-version>
      -DgroupId=<my.groupid>
      -DartifactId=<my-artifactId>


常用的Maven archetype plugin有：

*  org.apache.maven.archetypes:maven-archetype-quickstart
*  org.apache.maven.archetypes:maven-archetype-site
*  org.apache.maven.archetypes:maven-archetype-webapp
*  以及spring或者第三方提供了一些archetype plugin。


同时在java世界强大的IDE Intellij也支持按照maven archetype
创建java项目。你只需要选择maven 创建项目，在最后选择你希望的
archetype plugin，然后就可以喝杯coffe等待build success。


关于如何自定义项目的Maven archetype plugin，博主将会
在后续的文章介绍。在此次博文将是记录如果去掉你手动在intellij中添加
的archetype plugin。

mac版本，你可以找到文件：


    ~/Library/Caches/IntelliJIdea<version>/Maven/Indices/'UserArchetypes.xml
然后用你喜欢的编辑器打开它：


    <?xml version="1.0" encoding="UTF-8"?>
    <archetypes>
    <archetype groupId="com.github.greengerong" artifactId="components-archetype" version="1.0.0" />
    </archetypes>

你可以在xml的archetypes节点增加或者删除修改配置，然后重新启动你的Intellij。
