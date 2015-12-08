# todosails
todosails

Server API Testing
==================
create
curl -X POST -H "Authorization:Bearer xxx" --data "task=111&ownedBy=dorissschoi"  "http://localhost:1337/todo/api/todo/"


list
curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/?page=1&per_page=10&toDate=2015-12-29T15:59:00.000Z"

curl -X GET -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/?completed=true&page=1&per_page=10"

update
curl -X PUT -H "Authorization:Bearer xxx" --data "completed=true&task=00123&project=B&dateEnd=2015-11-16T02:00:00.000Z" "http://localhost:1337/todo/api/todo/xxx"

delete
curl -X DELETE -H "Authorization:Bearer xxx" "http://localhost:1337/todo/api/todo/xxx"


Configuration
=============
* git clone https://github.com/dorissschoi/todosails.git
* cd todosails
* npm install && bower install

update environment variables in config/env/development.coffee for server
* send im msg config
```
	im:
		sendmsg:	false #dev false not send 
```
update environment variables in www/js/env.cofffee for client

*	node_modules/.bin/gulp
*	sails lift --dev
