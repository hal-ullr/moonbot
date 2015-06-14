require "socket"



log = (str) ->
	print string.format "LOG:\009%s", str



msg = (client, message) ->
	log string.format "SENDING MESSAGE \"%s\" to client", message
	client\send message.."\r\n"



connect = (server, options) =>
	  --  Connect to server
--	log string.format "Connecting to %s server on %s", server, @port
--	log string.format "Using nick %s", @nick

	client = socket.connect server, @port
	  --  Basic connection lines; all connections begin with these
	msg client, string.format "USER %s 0 * :%s", @nick, @nick
	msg client, string.format "NICK %s", @nick
	
	callbacks = options.init
		join: (channel) ->
--			log string.format "Joining channel %s on server %s", channel, server
			msg client, string.format "JOIN %s", channel

		send: (message) ->
			msg client, message

	  --  Set client time-out
	client\settimeout 0.1
	  --  Loop for receiving messages
	while true
		message = client\receive!
		if message
--			log message
			if message == message\match "PING :.+"
				msg client, string.format "PONG %s", message\match "PING :(.+)"
			else
				callbacks.received message
			


export irc = {:connect}