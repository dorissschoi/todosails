module.exports = (req, res, next) ->
	req.options.values = req.options.values || {}

	if _.isUndefined(req.body.ownedBy)
		req.options.values.ownedBy = req.user.username
		
	#sails.log "req.options.values.ownedBy: " + req.options.values.ownedBy
			
	next()