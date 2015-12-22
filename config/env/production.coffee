path = '/todo'
agent = require 'https-proxy-agent'

module.exports =
	path:			path
	url:			"https://mob.myvnc.com/todouat"
	port:			8009

	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
		
	

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'db'
			port:		27017
			user:		'todouatrw'
			password:	'pass1234'
			database:	'todouat'	
		
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'todomsgUATAuth'
			secret: 'pass1234'
		user:
			id: 	'todoadmin'
			secret: 'pass1234'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"one new task"
		digesttxt:	"Overdue task"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"todoadmin@mob.myvnc.com"
		sendmsg:	true #dev not send
	
			