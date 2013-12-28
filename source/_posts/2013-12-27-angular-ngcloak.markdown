---
layout: post
title: "ngCloak 实现 angular 初始化闪烁最佳实践"
date: 2013-12-27 23:29:51 +0800
comments: true
categories:[angular,javascript] 
---

```js

	* @example
       <doc:example>
         <doc:source>
            <div id="template1" ng-cloak>{{ 'hello' }}</div>
            <div id="template2" ng-cloak class="ng-cloak">{{ 'hello IE7' }}</div>
         </doc:source>
         <doc:scenario>
           it('should remove the template directive and css class', function() {
             expect(element('.doc-example-live #template1').attr('ng-cloak')).
               not().toBeDefined();
             expect(element('.doc-example-live #template2').attr('ng-cloak')).
               not().toBeDefined();
           });
         </doc:scenario>
       </doc:example>
     *
     */
    var ngCloakDirective = ngDirective({
      compile: function(element, attr) {
        attr.$set('ngCloak', undefined);
        element.removeClass('ng-cloak');
      }
    });
    
```