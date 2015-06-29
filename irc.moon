require "socket" unless socket


local log
do
	logging = not not os.getenv "LOG"
	log = (str) ->
		if logging
			print string.format "LOG:\009%s", str


msg = (client, message) ->
	log string.format "SENDING MESSAGE \"%s\" to client", message
	client\send message.."\r\n"


connect = (server, options, init) ->

	import version, nick, port from options

	log string.format "Connecting to %s server on %s", server, port
	log string.format "Using nick %s", nick

	client = socket.connect server, port  --  Connect to server
	client\settimeout 0.1  --  Set client time-out

	msg client, string.format "USER %s 0 * :%s", nick, nick
	msg client, string.format "NICK %s", nick
	
	bot = init
		send: (message) -> msg client, message

		log: (message) -> log message

		join: (channel) ->
			log string.format "Joining channel %s on server %s", 
				channel, server
			msg client, string.format "JOIN %s", channel

		message: (at, message) ->
			msg client, string.format "PRIVMSG %s :%s", at, message

		me: (at, message) ->
			msg client, string.format "PRIVMSG %s :\001ACTION %s\001",
				at, message
	
	state = true

	while true  --  Loop for receiving messages
		if state
			state = coroutine.resume bot.init
		message = client\receive!
		if message
			bot.received message

					
			

export irc = { :connect }