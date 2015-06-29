export wait = (n) ->
	a = os.time!
	while os.time! <= a + n
		coroutine.yield!