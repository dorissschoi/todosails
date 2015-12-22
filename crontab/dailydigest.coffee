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

sendNotification = (values) ->
	fulfill = (result) ->
		if sails.config.im.sendmsg

			fulfillmsg = (result) ->
				sails.log.info "Notification is sent to " + result.body.to
			rejectmsg = (err) ->
				sails.log.error "Notification is sent with error: " + err
				
			#send msg	
			sendMsg(values, result.body.access_token).then fulfillmsg, rejectmsg
		else 	
			sails.log.warn "Send notification is disabled. Please check system configuration."
					
	reject = (err) ->
		sails.log.error "Error in authorization token : " + err
	getToken().then fulfill, reject
	
sendMsg = (values, todoAdminToken) ->
	return new Promise (fulfill, reject) ->
		opts = _.extend options, sails.config.http.opts,
			headers:
				Authorization:	"Bearer #{todoAdminToken}"

		data = 
			from: 	sails.config.im.adminjid
			to:		"#{values.ownedBy}@#{sails.config.im.xmpp.domain}"
			body: 	"#{sails.config.im.digesttxt}:#{values.taskCount}"

		http.post sails.config.im.url, data, opts, (err, res) ->
			#sails.log.info "post msg : " + JSON.stringify res.body
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
	run: (server) ->  
		opts = 
			skip:	0
			limit:	0
		currDate = new Date()
		cond =
			$and: [
				{ dateEnd: {$lte: currDate}}		
				{ completed: false }
			]
		sails.log.info 'Daily digest start at ' + currDate	
		sails.models.todo
			.find(cond, {ownedBy:1}, opts)
			.then (t) ->
				sails.log.info "overdue task count: " + t.length
				l = _.uniq(t, 'ownedBy')
				_.each l, (task) ->
					tasklist = _.where t, {ownedBy: task.ownedBy}
					#sails.log.info "ownedBy: " + JSON.stringify task.ownedBy + " taskCount: " + _.size(tasklist) 
					sendNotification _.extend(task, {taskCount: _.size(tasklist)})
			 		
	    	.catch (err) ->
	    		sails.log err
	    		
		return