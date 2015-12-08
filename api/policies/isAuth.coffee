passport = require 'passport'
bearer = require 'passport-http-bearer'
Promise = require 'promise'

# check if oauth2 bearer is available
verifyToken = (token) ->
	oauth2 = sails.config.oauth2
	
	return new Promise (fulfill, reject) ->
		sails.services.rest.get token, oauth2.verifyURL
			.then (res) -> 
				# check required scope authorized or not
				#sails.log "res.body: " + JSON.stringify res.body
				scope = res.body.scope.split(' ')
				
				#sails.log "scope: " +scope
				#sails.log "oauth2.scope: " +oauth2.scope
	
				result = _.intersection scope, oauth2.scope
				if result.length != oauth2.scope.length
					return reject('Unauthorized access to #{oauth2.scope}')
								
				user = _.pick res.body.user, 'url', 'username', 'email'
				
				
								
				###skip create user###
				sails.models.user
					.findOrCreate user
					.populateAll()
					.then fulfill, reject
				######################
				fulfill user
										
			.catch reject
			
passport.use 'bearer', new bearer.Strategy {}, (token, done) ->
	fulfill = (user) ->
		user.token = token
		done(null, user)
	reject = (err) ->
		done(null, false, message: err)
	verifyToken(token).then fulfill, reject
	
module.exports = (req, res, next) ->
	middleware = passport.authenticate('bearer', { session: false })
	middleware req, res, ->
		next()