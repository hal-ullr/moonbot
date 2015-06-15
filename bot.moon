require "moonscript"
require "irc"

irc.port = 6666
irc.nick = "moonbot"



irc.connect "irc.rizon.net", { :nick, :port }
	init: (funcs) ->
		import join, send from funcs
		
		join "#/g/technology"
		
		received: (msg) ->
			if (string.sub msg, 1, 1) == ":"
				user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
				if command == "PRIVMSG" then
--					irc.log msg
					if text == ".bots"
						print at
						send string.format "PRIVMSG %s :Reporting in! [Moonscript]", at	