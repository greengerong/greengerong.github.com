---
layout: post
title: "ng-template寄宿方式"
date: 2014-03-15 16:14:55 +1100
comments: true
categories: [angular,javascript,java]
---
如果你是一个angular的开发者的话，对于ng-html2js你应该
很熟悉。对于angular的指令，我们经常需要定义模板(
directive template/templateUrl),你可以选择讲html page
放在真正的的web容器中寄宿，也可以选择angular的ng-template
放在view的page之上，抑或也可以讲html打成一个js文件和directive
的js文件合并在一起发布。

* 对于直接寄宿在web容器.

  这很简单，直接放在jetty，tomcat，iis，
  抑或node express public目录下。这里没什么可以多说的，所以我们跳过。

* angular ng-template模板:

  代码如下：


          <script type="text/ng-template" id="/tpl.html">

            Content of the template.

          </script>


  这将会在angular的compile时候解析，angular将会把它放在angular的$templateCache
  中。

  对于[$templateCache](http://docs.angularjs.org/api/ng/service/$templateCache)，如其名
  这是angular对模板的缓存的service。在启用了$templateCache的$http ajax请求，
  angular将会首先在$templateCache中查找是否有对此url的缓存：


            $templateCache.get('templateId.html')


  如果存在缓存，着angular将会直接用缓存中获取，并不会在发送一次ajax。
  对于所有的指令和模板angular默认启用了templateCache。

  这在于angular所处理的模式开发很有关系的。我们经常提到的SPA(single page application)
  我们把view的显示处理等表现逻辑推到了前段，而后端提供只与数据有关的soap/restful service
  这样对于一个应用程序业务逻辑来说不变的是处理数据的业务逻辑，这份逻辑你可以共享在不管前端是mobile
  app 或者是浏览器，或者winform gui的图形化程序，因为对于同一个业务这是不变的。将view的分离推到各自的客户端
  将是更好的解决方案。

  回到angular $templateCahce，对于一个应用程序view的分离，之后在对于当前的应用程序平台，html/js/css
  这类资源是静态的，最好是不变的，那么你可以自由的缓存在客户端，减少服务器的交互，以及为了更大的性能追求，我们
  可以把这类静态资源放在Nginx这里反向代理或者CDN上，让我们的程序获取更大的性能和扩展空间。


* 回到angular的ng-html2js：

  有了上边对于$templateCache的理解，那你应该很容易理解html2js的方式了，与ng-template不同的
  是ng-template是angular在compile的时候自动加入$templateCache的，html2js是我们在开发
  时候利用build自己放入$templateCache。


        angular.module('myApp', [])
        .run(function($templateCache) {
            $templateCache.put('templateId.html',
                'This is the content of the template'
            );
        });


形如上面的输出，将html文件打成一个js文件。

这你也许在angular的单元测试karma unit test中看见过，[ karma-ng-html2js-preprocessor](https://github.com/karma-runner/karma-ng-html2js-preprocessor)
，还有如果你也希望在build时候做到如此，那么你可以使用grunt plugin [ grunt-html2js](https://github.com/karlgoldstein/grunt-html2js).


但使用grunt plugin的前提是你在你的项目中引入的grunt build的work flow，那么你可以在gruntfile.js中几行代码轻松的搞定。但是如果
你和我一样使用的是java的maven或者是gradle 作为build，那么你可以尝试博主的maven plugin[nghtml2js](https://github.com/greengerong/nghtml2js).
使用方式如下：


    <plugin>
        <groupId>com.github.greengerong</groupId>
        <artifactId>nghtml2js</artifactId>
        <version>0.0.3</version>
        <configuration>
            <module>demo.template</module>
            <html>${project.basedir}</html>
            <extensions>
                <param>tpl</param>
                <param>html</param>
            </extensions>
        </configuration>
        <executions>
            <execution>
                <id>nghtml2js</id>
                <phase>generate-resources</phase>
                <goals>
                    <goal>run</goal>
                </goals>
            </execution>
        </executions>
    </plugin>
