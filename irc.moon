require "socket" if not socket


log = (str) -> print string.format "LOG:\009%s", str


msg = (client, message) ->
	log string.format "SENDING MESSAGE \"%s\" to client", message
	client\send message.."\r\n"


connect = (server, options, callbacks) ->

	import nick, port from options

	log string.format "Connecting to %s server on %s", server, port
	log string.format "Using nick %s", nick

	client = socket.connect server, port  --  Connect to server
	
	msg client, string.format "USER %s 0 * :%s", nick, nick
	msg client, string.format "NICK %s", nick
	
	bot = callbacks.init
		join: (channel) ->
			log string.format "Joining channel %s on server %s", 
				channel, server
			msg client, string.format "JOIN %s", channel

		send: (at, message) ->
			msg client, string.format "PRIVMSG %s :%s", at, message

	client\settimeout 0.1  --  Set client time-out
	
	while true  --  Loop for receiving messages
		message = client\receive!
		if message
			if message == message\match "PING :.+"
				msg client, string.format "PONG %s", 
					message\match "PING :(.+)"
			else
				bot.received message
			

export irc = { :connect }