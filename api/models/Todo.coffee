Promise = require 'promise'
fs = require 'fs'
http = require 'needle'

dir = '/etc/ssl/certs'
files = fs.readdirSync(dir).filter (file) -> /.*\.pem/i.test(file)
files = files.map (file) -> "#{dir}/#{file}"
ca = files.map (file) -> fs.readFileSync file

options = 
	timeout:	sails.config.promise.timeout
	ca:			ca

sendMsg = (values, todoAdminToken) ->
	return new Promise (fulfill, reject) ->
	
		opts = _.extend options, sails.config.http.opts,
			headers:
				Authorization:	"Bearer #{todoAdminToken}"
		#sails.log "opts.headers: " + JSON.stringify opts.headers
		data = 
			from: 	sails.config.im.adminjid
			to:		"#{values.createdBy}@#{sails.config.im.xmpp.domain}"
			body: 	sails.config.im.txt	+ " : "+ values.task	
		#sails.log "data: " + JSON.stringify data
		
		http.post sails.config.im.url, data, opts, (err, res) ->
			sails.log "post msg : " + JSON.stringify res.body
			if err
				return reject err
			fulfill res

getToken = (values) ->
	return new Promise (fulfill, reject) ->
		sails.services.rest.token sails.config.oauth2.tokenURL, sails.config.im.client, sails.config.im.user, sails.config.im.scope
			.then (res) ->
				#sails.log "return todoadmin access_token: " + JSON.stringify res.body.access_token
				fulfill res
			.catch reject
				
module.exports =
	tableName:		'todos'
  
	schema: 		true
  
	attributes:
  
		task:
			type: 'string'
			required:	true

		location:
			type: 'string'

		project:
			type: 'string'

		notes:
			type: 'string'

		completed:
			type: 'boolean'
			defaultsTo: false

		dateEnd:
			type: 'date'

		createdBy:
			type: 'string'

		ownedBy:
			type: 'string'
				  
	afterCreate: (values, cb) ->
		
		#get token 		
		fulfill = (result) ->
			sails.log "getToken fulfill: " + result.body.access_token
			if sails.config.im.sendmsg
				fulfillmsg = (result) ->
					sails.log "sendMsg fulfill"	
				rejectmsg = (err) ->
					sails.log "sendMsg reject"
				#send msg	
				sendMsg(values, result.body.access_token).then fulfillmsg, rejectmsg
			else 	
				sails.log "config not send msg"
		reject = (err) ->
			sails.log "getToken reject"
		getToken(values).then fulfill, reject
		
		
		
		return cb null, values  