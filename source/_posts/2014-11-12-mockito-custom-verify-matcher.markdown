---
layout: post
title: "Mockito自定义verify参数Matcher"
date: 2014-11-12 13:53:13 +0800
comments: true
categories: [java, TDD]
---
在TDD开发中，也许我们会遇见对一些重要的无返回值的行为测试，比如在用户的积分DB中增加用户的积分，这个行为对于我们的业务具有重要的价值，所以我们也希望能测试覆盖这部分业务价值。这个时候我们就得使用mockito带来的verify断言，但verify的参数断言主要有eq，或者any常见的方式。有时我们也希望能够断言对象的一部分属性，比如上文的积分数值，对于不同的场景增加的用户积分可能不同。

回到Mockito的参数Matcher，Mockito给我们提供了ArgumentMatcher，以供我们来扩展Matcher。下面假设一个增加用户积分的场景：

		 public class Game {
	        private String type;
	        private int rate;

	        public Game(String type, int rate) {
	            this.type = type;
	            this.rate = rate;
	        }

	        public String getType() {
	            return type;
	        }

	        public int getRate() {
	            return rate;
	        }

	    }

	    public class GameDao {
	        public void addRate(Game game) {
	            //TODO: insert to db
	        }
	    }


我们希望能够对verify GameDao调用了addRate，并且是积分rate为特定值。

所以我们可以扩展Mockito的ArgumentMatcher：

	public class PartyMatcher<T> extends ArgumentMatcher<T> {
	    private Object value;
	    private Function<T, Object> function;

	    public PartyMatcher(Function<T, Object> getProperty, Object value) {
	        this.value = value;
	        this.function = getProperty;
	    }

	    public static <F> PartyMatcher<F> partyMatcher(Function<F, Object> getProperty, Object value) {
	        return new PartyMatcher<F>(getProperty, value);
	    }

	    @Override
	    public boolean matches(Object o) {
	        return function.apply((T) o).equals(value);
	    }
	}


所以我们的测试可以如下：

	    @Test
	    public void should_run_customer_mockito_matcher() throws Exception {

	        final GameDao gameDao = mock(GameDao.class);
	        gameDao.addRate(new Game("签到", 7));

	        verify(gameDao).addRate(argThat(new PartyMatcher<Game>(new Function<Game, Object>() {
	            @Override
	            public Object apply(Game game) {
	                return game.getRate();
	            }
	        }, 7)));

	        verify(gameDao).addRate(argThat(new PartyMatcher<Game>(new Function<Game, Object>() {
	            @Override
	            public Object apply(Game game) {
	                return game.getType();
	            }
	        }, "签到")));
	    }


Mockito给我们提供了很多关于Matcher扩展的方法，本文只是ArgumentMatcher的实例。