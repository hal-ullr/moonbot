require "socket"
require "moonscript"
require "irc"


port = 6666
nick = "moonbot"


privmsg = (lib, message) ->

	import text, user, at from message

	if text == ".bots"
		lib.send at, "Reporting in! [Moonscript]"


parse = (lib, msg) ->
	if (string.sub msg, 1, 1) == ":"
		user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
		if command == "PRIVMSG"
			privmsg lib, { :text, :user, :at }


irc.connect "irc.rizon.net", :nick, :port 
	init: (lib) ->
		socket.sleep 1
		lib.join "#/g/technology"
		received: (msg) -> parse lib, msg