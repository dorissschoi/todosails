# util.auth
util.auth is an angular module for application to verify user login via pre-defined oauth2 server on pop-up iframe. 

## Usage
Install the required packages
```
bower install util.auth lodash sails.io.js angular angular-animate angular-sanitize angular-ui-router ionic sails-auth
```

Define oauth2 server settings 
```
	io.sails.url = 'https://mob.myvnc.com'
	io.sails.path = "/im.app/socket.io"
	io.sails.useCORSRouteToGetCookie = false
		
	module.exports = 
		oauth2:
			opts:
				authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
				response_type:	"token"
				scope:			"https://mob.myvnc.com/org/users"
				client_id:		'util.auth'
```

Include required packages as shown in test/io.coffee or test/rest.coffee
```
	require 'util.auth'
```

Include sails.io.js and disable autoConnect

```
	<script type="text/javascript" src="lib/sails.io.js/dist/sails.io.js"></script>
	<script type="text/javascript">
		io.sails.autoConnect = false;
	</script>
```

Run login via the pre-defined oauth2 server settings once 401 Unauthorized Access is received 
```
angular.module 'app', ['util.auth', ...]
	.run (authService) ->
		authService.login env.oauth2.opts
```

## Demo
Open browser to visit https://mob.myvnc.com/util.auth/io.html or https://mob.myvnc.com/util.auth/rest.html.

Deploy to local testing server
```
  npm install && bower install
  node_modules/.bin/gulp
  node_modules/.bin/http-server ./test -p 8080
```
open browser to visit http://localhost:8080/test/io.html or http://localhost:8080/test/rest.html