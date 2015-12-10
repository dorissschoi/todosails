# todosails
todosails

Server API Testing
==================
create
```
curl -X POST -H "Authorization:Bearer xxx" --data "task=111&ownedBy=dorissschoi"  "http://localhost:1337/todo/api/todo/"
```
list 7 days task, completed task
```
curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/?page=1&per_page=10&toDate=2016-12-29T15:59:00.000Z"
curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/?completed=true&page=1&per_page=10"
```
update
```
curl -X PUT -H "Authorization:Bearer xxx" --data "completed=true&task=00123&project=B&dateEnd=2015-11-16T02:00:00.000Z" "http://localhost:1337/todo/api/todo/xxx"
```
delete
```
curl -X DELETE -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/xxx"
```

Configuration
=============
* update Nginx port no
* create a/c 'todoadmin' and login in to im.app as JID 'todoadmin@mob.myvnc.com' to send msg
* use 'todoadmin' create oauth2 cliendID: todomsgDEVAuth with Auth type 'password' and 'confidential'
* update sendmsg to im.app boolean 'im.sendmsg'
* update MongoDB connection and user
* update environment variables in config/env/development.coffee for server

```
	path:			path
	url:			"http://localhost:1337#{path}"
	port:			1337
	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'todomsgDEVAuth'
			secret: 'pass1234'
		user:
			id: 	'todoadmin'
			secret: 'pass1234'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"one new task"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"todoadmin@mob.myvnc.com"
		sendmsg:	true #dev not send 
```
* update environment variables in www/js/env.cofffee for client
* oauth2 scope client/server should be the same 
```
	oauth2:
		authUrl: "#{@authUrl}/org/oauth2/authorize/"
		opts:
			authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
			response_type:  "token"
			scope:          "https://mob.myvnc.com/org/users"
			client_id:      'todoSailsDEVAuth'
```

* git clone https://github.com/dorissschoi/todosails.git
* cd todosails
* npm install && bower install
*	node_modules/.bin/gulp
*	sails lift --dev
