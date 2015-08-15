#!/bin/env moon

require "socket"
require "moonscript"
require "thread"
require "irc"


version = "moonbot 0.2" .. string.format " [%s] on [%s]",
	"MoonScript " .. (require "moonscript.version").version,
	_VERSION


irc.connect
	server: "irc.rizon.net"
	port: 6666
	nick: "moonbot"
	version: version 
	callback: ->
		init = coroutine.create ->
			wait 10
			do
				password = os.getenv "PASSWORD"
				message "NickServ", "IDENTIFY " .. password if password
			wait 2
			join "#rice"

		received = (msg) ->  --  Function for receiving messages
			if msg == msg\match "PING :.+"
				send string.format "PONG %s",
					msg\match "PING :(.+)"

			elseif msg == msg\match ":[^%s]+ PRIVMSG [^%s]+ :\001VERSION\001"
				log "Sent version %s"\format version
				send string.format "NOTICE %s :\001VERSION %s\001", 
					msg\match ":(.-)![^%s]+ PRIVMSG [^%s]+ :\001VERSION\001",
					version

			elseif (string.sub msg, 1, 1) == ":"
				user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
				if command == "PRIVMSG"
					if text == ".bots"
						message at, string.format "Reporting in!"
--					if text == ".me"
--						me at, "test"
			
		{ :init, :received }