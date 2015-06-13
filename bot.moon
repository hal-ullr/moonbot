require "moonscript"
require "irc"

irc.logging = 2
irc.port = 6666
irc.nick = "moonbot"

irc\connect "irc.rizon.net"
	init: =>
		@join "#/g/technology"

	received: (msg) =>
		if (string.sub msg, 1, 1) == ":"
			user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
			if command == "PRIVMSG" then
				irc\log 2, msg