require "moonscript"
require "irc"


port = 6666
nick = "ban_ki-moon"


privmsg = (message) =>

	import text, user, at from message

	if text == ".bots"
		@send string.format "PRIVMSG %s :Reporting in! [Moonscript]", at


parse = (msg) =>
	if (string.sub msg, 1, 1) == ":"
		user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
		if command == "PRIVMSG"
			privmsg @, { :text, :user, :at }


irc.connect "irc.rizon.net", :nick, :port 
	init: =>
		@join "#or/g/y"
		received: (msg) -> parse @, msg