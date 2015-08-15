#!/bin/env moon

require "thread"
require "moon.all"

log = do
	logging = not not os.getenv "LOG"
	(str) ->
		print string.format "LOG:\009%s", str if logging

logf = (str, ...) -> log string.format str, ...


msgr = (client, message) ->
	log string.format "SENDING MESSAGE \"%s\" to client", message
	client\send message.."\r\n"

msgf = (client, str, ...) -> msgr client, string.format str, ...


connect = (options) ->

	import callback, server, version, nick, port from options

	logf "Connecting to %s server on %s", server, port
	logf "Using nick %s", nick

	client = socket.connect server, port  --  Connect to server
	client\settimeout 0.1  --  Set client time-out

	msgf client, "USER %s 0 * :%s", nick, nick
	msgf client, "NICK %s", nick
	
	bot = run_with_scope callback,
		send: (msg) -> msgr client, msg
		log: (msg) -> log msg
		join: (channel) -> msgf client, "JOIN %s", channel
		message: (at, msg) -> msgf client, "PRIVMSG %s :%s", at, msg
		me: (at, msg) -> msgf client, "PRIVMSG %s :\001ACTION %s\001", at, msg
	
	state = true

	while true  --  Loop for receiving messages
		state = coroutine.resume bot.init if state
		message = client\receive!
		bot.received message if message

export irc = { :connect }