---
layout: post
title: "隐藏在mock之后的‘快感’"
description: "隐藏在mock之后的‘快感’"
category: cnblogs
tags: [code,cnblogs]
---
&nbsp;&nbsp; &nbsp; &nbsp;最近某同事抱怨他们的测试难写，经常花费在测试的时间比产品代码更多，而且每次重构后都必须修改一大堆的测试。和同事闲谈后得知，在其项目中大量的使用了mock，或者说对mock的使用过度极端对所谓的单元测试&ldquo;快速&rdquo;，&ldquo;独立&ldquo;的过度。 在前边转载过《软件开发中没有所谓正确的方法》，当你把某一种方法论作为银弹使用的时候，早晚魔鬼会伴随在你身边。

&nbsp; &nbsp; &nbsp;Mock给我带来了感知，剥离了类与类之间的依赖，有助于我们更好的工作在当前的关注点 .但同时由于太多的对场景的假设，导致这块代码成为了信息的孤岛，甚至很多时候不得不用mock的第二特性verify，order，以至于你的测试关心的不再是代码存在的business逻辑，而倾向代码层面的设计实现，这就把你单元测试推向了&ldquo;白盒测试&ldquo;的位置，导致测试变为脆弱的测试。每当简单的重构导致内部的变化，你的测试也必须随着改变。

&nbsp; &nbsp; &nbsp;鄙人认为作为一个好的测试而言，在一次合法的简单重构之下，是不需要修改测试的，因为你修改的只是内部实现，而不是business的改变，如果你边改测试边重构或者重构后挂到一大堆测试，这意味这你的测试不是一个稳定的测试或者你不是一次合法的重构（也许redesign，override）。

&nbsp; &nbsp; &nbsp;在同事的项目中对mock的极端到了对简单的View Object 也采用builder模式，可是内部却全是mock given。在我看来而言View Object只是一个简单的数据载体，不存在行为逻辑，我们毫无必要去做mock，mock该是针对假设，而应该尽量避免对状态mock。在同事的项目中导致需要写一个测试之前，作为测试的准备given ，必须理解存在代码的实现，因为你需要一堆given，比如对于person对象，如果你在实现中需要得到account则：

given(person.getAccount()).willReturn(some account);

&nbsp; &nbsp; &nbsp;导致我需要了解实现需要什么property，如果我需要新的的property也许只是简单的把某个&ldquo;依恋情结&rdquo;放入了object，测试也需要被修改，导致重构者对自己的重构并不那么自信，这将影响重构成为日常行为，随着堆积的&rdquo;坏味道&ldquo;这将一点一点的侵蚀你的代码，项目慢慢的也许会不能的不可控。

&nbsp; &nbsp; &nbsp;Mock并不是一个坏的东西，结果的好坏在于使用的人，团队 的意识，如果是mock anywhere或者杜绝mock走向两个任意的极端都将是一个错误的抉择。

&nbsp; &nbsp; &nbsp;Mock更多的使用场景为对外界资源解依赖增强感知能力，以及对无响应的重要business的验证，后者长体现于一个没有返回子void的method，但是method比如增加用户积分，记录用户信息等的。然而对于有响应的business，我需要的不是mock而应该是assert，对于测试来说对于business来说应试是我的输入应该得到我预期的响应，而非我verify某个行为发生了，那么其结果一定就正确，当然对于实现来说这是成立的，但是从测试的价值来说这厮无意义的，这将是一个脆弱的测试，我认为一个好的测试将是&ldquo;黑盒测试&ldquo;，是一个business的描述，对一份约定，契约的阐述。

&nbsp; &nbsp; &nbsp; 附言，如果你因为测试的速度，独立性来为自己的mock证明，那将是无意义的，不是每一个测试都必须在黄金法则内（0.1s），如果你对外部依赖，耗时依赖的分离，这我相信将不再是问题所在，测试的优化将是另一个有趣的话题，将不是本文内容之列。

&nbsp;

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本文通过程序[cnblogs-blogs2markdown](https://github.com/greengerong/cnblogs-blogs2markdown "cnblogs-blogs2markdown")转换的,如质量有问题[原文首发请看这里](http://www.cnblogs.com/whitewolf/archive/2013/05/29/3107019.html "原文首发")