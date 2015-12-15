actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

# check if authenticated user is model owner  
module.exports = (req, res, next) ->
	
	model = req.options.model || req.options.controller
	Model = actionUtil.parseModel(req)
	pk = actionUtil.requirePk(req)
	if model == 'user' and pk == req.user.username
		return next()
	
	###	
	cond = 
			id:			pk
			createdBy:	req.user.username
	###
	cond =
		or: [
			{
				id:			pk
				createdBy:	req.user.username
			}
			{
				id:			pk
				ownedBy:	req.user.username
			}
		]
	
	#sails.log "isOwnerOrCreatedBy cond: " + JSON.stringify cond 
				
	Model.findOne()
		.where( cond )
		.exec (err, data) ->
			if err
				return res.serverError err
			if data
				return next()
			res.notFound()
	