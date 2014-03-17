---
layout: post
title: "自定义项目脚手架- mvean archetypes"
date: 2014-03-17 08:14:21 +1100
comments: true
categories: [java, maven]
---
在上篇[Intellij修改archetype Plugin配置](http://greengerong.github.io/blog/2014/03/16/intellij-remove-archetype-plugin/)
中我们已经简单介绍了关于archetype的作用。

简单来说maven archetype插件就是下哦昂木创建的脚手架，
通过命令行或者IDE集成简化我们创建项目的工作。例如：

*  org.apache.maven.archetypes:maven-archetype-quickstart
*  org.apache.maven.archetypes:maven-archetype-site
*  org.apache.maven.archetypes:maven-archetype-webapp
*  以及spring或者第三方提供了一些archetype plugin。


同时maven archetype插件也是一个简单的maven artifact，它包含了创建项目所需要的所有资源。
主要分为几类原型信息：

*  archetype描述文件(src/main/resources/META-INF/maven/archetype.xml),这为[archetype 1.0](http://maven.apache.org/plugins/maven-archetype-plugin-1.0-alpha-7/),
包含所有创建项目的文件信息和路径信息。在(archetype 2.0)[http://maven.apache.org/archetype/maven-archetype-plugin/]增加了更灵活的archetype-metadata.xml(src/main/resources/META-INF/maven/下),
archetype元数据信息，并且完全支持1.0.
*  项目的原型文件(src/main/resources/archetype-resources/之下)，将会被archetype插件
copy到项目目录结构去。
*  创建项目的pom文件(src/main/resources/archetype-resources下)
*  archetype pom文件，在archetype项目根目录下。

####创建archetype插件

1.  首先在archetype中加入一个pom文件，如下：


        <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
              <modelVersion>4.0.0</modelVersion>
              <groupId>com.github.greengerong</groupId>
              <artifactId>component</artifactId>
              <version>0.0.1-SNAPSHOT</version>
              <packaging>jar</packaging>

              <name>component</name>
              <url>http://maven.apache.org</url>

              <properties>
                  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
              </properties>

              <dependencies>
              </dependencies>
        </project>


2.  创建archetype-metadata.xml,位于src/main/resources/META-INF/maven/目录下，例如：


        <?xml version="1.0" encoding="UTF-8"?>
        <archetype-descriptor name="app-server">
            <fileSets>
                <fileSet filtered="true" encoding="UTF-8">
                    <directory>src/main/java</directory>
                    <includes>
                        <include>**/*.**</include>
                    </includes>
                </fileSet>
                <fileSet filtered="true" encoding="UTF-8">
                    <directory>src/test/java</directory>
                    <includes>
                        <include>**/*.**</include>
                    </includes>
                </fileSet>
            </fileSets>
        </archetype-descriptor>


更多配置信息参考[archetype-descriptor](https://maven.apache.org/archetype/archetype-common/archetype-descriptor.html).


3.  为将创建的项目增加pom.xml文件，以${artifactId} / ${groupId} 变量作为占位符，例如：


          <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
              <modelVersion>4.0.0</modelVersion>
              <groupId>${groupId}</groupId>
              <artifactId>${artifactId}</artifactId>
              <version>${version}</version>
              <packaging>jar</packaging>

              <name>${artifactId}</name>

              <properties>
                  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
              </properties>

              <dependencies>
                  <dependency>
                      <groupId>junit</groupId>
                      <artifactId>junit</artifactId>
                      <version>4.11</version>
                      <scope>test</scope>
                  </dependency>
              </dependencies>

              <build>
                  <pluginManagement>
                      <plugins>
                          <plugin>
                              <artifactId>maven-compiler-plugin</artifactId>
                              <configuration>
                                  <source>1.6</source>
                                  <target>1.6</target>
                              </configuration>
                          </plugin>
                      </plugins>
                  </pluginManagement>
              </build>
          </project>


4.  接下来在archetype项目下install plugin：mvn clean install.

5.  利用已有crchetype plugin创建项目：

    命令行：


        mvn archetype:generate -DarchetypeGroupId=<archetype-groupId>  -DarchetypeArtifactId=<archetype-artifactId> -DarchetypeVersion=<archetype-version>  -DgroupId=<my.groupid> -DartifactId=<my-artifactId>


  intellij选择增加archetype plugin：
  ![/images/blog_img/Intellij-archetype-plugin.png](/images/blog_img/Intellij-archetype-plugin.png)

对于删除intellij test archetype信息，请参见[Intellij修改archetype Plugin配置](http://greengerong.github.io/blog/2014/03/16/intellij-remove-archetype-plugin/).

注意：

*  如果你也需要文件名字或者目录名字，则需要用特殊变量\_\_artifactId\_\_(双下划线)作为占位符。


如果你想直接尝试本文demo,请移到到github [maven-archetypes-demo](https://github.com/greengerong/maven-archetypes-demo).
