# todosails
todosails

Server API Testing
==================
create 

1) login user create task, ownedBy eq to createdBy, dateEnd default to null, can update and del
```
curl -X POST -H "Authorization:Bearer xxx" --data "task=ABC"  "http://localhost:1337/api/todo/"
```
2) system create task, specific ownedBy username, dateEnd default to null, ownedBy user can update only
```
curl -X POST -H "Authorization:Bearer xxx" --data "task=111&ownedBy=dorissschoi"  "http://localhost:1337/api/todo/"
```
list 

1) list no schedule, uncompleted, within 7 days task, completed task ownedBy login user
```
curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/api/todo?limit=10&skip=0&sort=dateEnd+ASC&toDate=2015-12-21T15:59:59.999Z"
```
2) list no schedule completed ownedBy login user
```
curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/api/todo?completed=true&limit=10&skip=0&sort=dateEnd+ASC"
```
update task by createdBy user or ownedBy user can update
```
curl -X PUT -H "Authorization:Bearer xxx" --data "completed=true&task=00123&project=B&dateEnd=2015-11-16T02:00:00.000Z" "http://localhost:1337/api/todo/xxx"
```
delete task by createdBy user
```
curl -X DELETE -H "Authorization:Bearer xxx" "http://localhost:1337/api/todo/xxx"
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
