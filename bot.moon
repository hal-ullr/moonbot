require "socket"
require "moonscript"
require "thread"
require "irc"


port, nick = 6666, "moonbot"

moonversion = "MoonScript " .. (require "moonscript.version").version
luaversion = _VERSION

version = string.format "moonbot 0.1 [%s] [%s]",
	moonversion,
	luaversion


privmsg = (lib, message) ->

	import text, user, at from message

	if text == ".bots"
		lib.message at, string.format "Reporting in! [%s on %s]",
			moonversion,
			luaversion

	if text == ".me"
		lib.me at, "test"


parse = (lib, msg) ->
	if (string.sub msg, 1, 1) == ":"
		user, command, at, text = msg\match ":([^%s]+) ([^%s]+) ([^%s]+) :?(.+)"
		if command == "PRIVMSG"
			privmsg lib, { :text, :user, :at }


irc.connect "irc.rizon.net", :nick, :port, :version, (lib) -> {
	init: fork ->
		wait 10
		do
			password = os.getenv "PASSWORD"
			lib.message "NickServ", "IDENTIFY " .. password if password
		wait 2
		lib.join "#muhbottest"

	received: (message) -> 
		if message == message\match "PING :.+"
			lib.send string.format "PONG %s", 
				message\match "PING :(.+)"

		elseif message == message\match ":[^%s]+ PRIVMSG [^%s]+ :\001VERSION\001"
			lib.log ("Sent version %s"\format version)
			lib.send string.format "NOTICE %s :\001VERSION %s\001", 
				message\match ":(.-)![^%s]+ PRIVMSG [^%s]+ :\001VERSION\001",
				version

		else
			parse lib, message
}