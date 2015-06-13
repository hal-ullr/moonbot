require "socket"

swap = {
	{1, 7}, {0, 0}, {0, 4}, {0, 2}, {1, 1}, {0, 1}, {0, 5}, {0, 3}
	{1, 3}, {1, 2}, {0, 6}, {1, 6}, {1, 4}, {1, 5}, {1, 0}, {0, 7}
}

ircmsg = (str) ->
	  --  Replace ansi escape sequence char with symbol
	str = string.gsub str, "\027", "\\027"

	str = string.gsub str, "\003(%d%d?),(%d%d?)", (c1, c2) ->
		table.concat { 
			string.format "\027[%s;3%sm",
				unpack swap[c1 + 1]
			string.format "\027[%sm",
				((c) -> ({"4", "10"})[c[1] + 1] .. c[2]) swap[c2 + 1]
		}

	string.gsub str, "\003(%d?%d?)", (c1) ->
			return if c1 != ""
				string.format "\027[%s;3%sm",
					unpack swap[c1 + 1]
			else
				"\027[0m"




log = (e, str) =>
	if e <= @logging
		print string.format "\027[1;3%smLOG:\009\027[0m%s", e, ircmsg str





send = (client, message) =>
	@log 1, string.format "SENDING MESSAGE \"%s\" to client", message
	client\send message.."\r\n"

connect = (server, options) =>
	  --  Connect to server
	irc\log 1, string.format "Connecting to %s server on %s", server, @port
	irc\log 1, string.format "Using nick %s", @nick

	client = socket.connect server, @port
	  --  Basic connection lines; all connections begin with these
	@send client, string.format "USER %s 0 * :%s", @nick, @nick
	@send client, string.format "NICK %s", @nick
	
	options.join = (channel) =>
		irc\log 1, string.format "Joining channel %s on server %s", channel, server
	options\init!
	  --  Set client time-out
	client\settimeout 0.1
	  --  Loop for receiving messages
	while true
		message = client\receive!
		if message
			irc\log 3, message
			if message == message\match "PING :.+"
				@send client, string.format "PONG %s", message\match "PING :(.+)"
			else
				options\received message
			





export irc = {:connect, :log, :send, :join}