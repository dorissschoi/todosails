http = require 'needle'
Promise = require 'promise'
fs = require 'fs'

dir = '/etc/ssl/certs'
files = fs.readdirSync(dir).filter (file) -> /.*\.pem/i.test(file)
files = files.map (file) -> "#{dir}/#{file}"
ca = files.map (file) -> fs.readFileSync file

options = 
	timeout:	sails.config.promise.timeout
	ca:			ca

sendIM = (values, todoAdminToken) ->
	return new Promise (fulfill, reject) ->
		opts = _.extend options, sails.config.http.opts,
			headers:
				Authorization:	"Bearer #{todoAdminToken}"

		if _.has(values, 'taskCount')
			data = 
				from: 	sails.config.im.adminjid
				to:		"#{values.ownedBy}@#{sails.config.im.xmpp.domain}"
				body: 	"#{sails.config.im.digesttxt}:#{values.taskCount}"
		else
			data = 
				from: 	sails.config.im.adminjid
				to:		"#{values.ownedBy}@#{sails.config.im.xmpp.domain}"
				body: 	sails.config.im.txt	+ " : "+ values.task					

		http.post sails.config.im.url, data, opts, (err, res) ->
			sails.log.info "post msg : " + JSON.stringify _.pick res.body, "from","to","body"
			if err
				return reject err
			fulfill res	
	
getToken = ->
	return new Promise (fulfill, reject) ->
		sails.services.rest.token sails.config.oauth2.tokenURL, sails.config.im.client, sails.config.im.user, sails.config.im.scope
			.then (res) ->
				fulfill res
			.catch reject
			
module.exports = 
	sendMsg: (values) ->
		#sails.log.info "sendOverdueMsg to:" + JSON.stringify values
		fulfill = (result) ->
			if sails.config.im.sendmsg
	
				fulfillmsg = (result) ->
					sails.log.info "Notification is sent to " + result.body.to
				rejectmsg = (err) ->
					sails.log.error "Notification is sent with error: " + err
					
				#send msg	
				sendIM(values, result.body.access_token).then fulfillmsg, rejectmsg
			else 	
				sails.log.warn "Send notification is disabled. Please check system configuration."
						
		reject = (err) ->
			sails.log.error "Error in authorization token : " + err
		getToken().then fulfill, reject

	