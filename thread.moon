export wait = (n) ->
	a = os.time!
	while os.time! <= a + n
		coroutine.yield!

export fork = coroutine.create

export resume = coroutine.resume