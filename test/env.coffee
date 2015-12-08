io.sails.url = 'https://mob.myvnc.com:443'
io.sails.path = "/im.app/socket.io"
io.sails.useCORSRouteToGetCookie = false

module.exports =
	server:
		rest:
			urlRoot:	'https://mob.myvnc.com/org'
		io:
			urlRoot:	'https://mob.myvnc.com/im.app'
	oauth2:
		rest:
			authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
			response_type:	"token"
			scope:			"https://mob.myvnc.com/org/users"
			client_id:		'todoSailsDEVAuth'
		io:
			authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
			response_type:	"token"
			scope:			"https://mob.myvnc.com/org/users https://mob.myvnc.com/mobile"
			client_id:		'util.auth'