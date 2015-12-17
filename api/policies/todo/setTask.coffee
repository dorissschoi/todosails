actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

# add criteria for todo  
module.exports = (req, res, next) ->
	values = actionUtil.parseValues(req)
	dateEnd = values.toDate
	completed = values.completed

	if !_.isUndefined(dateEnd)
		cond =
			$and: [
				{ $or: [
						{ownedBy: req.user.username},{createdBy: req.user.username}]	
				}
				{ $or: [
						{dateEnd: {$lte: req.query.toDate}},{dateEnd: null}]		
				}	
				{ completed: false }
			]
			
	if !_.isUndefined(completed)
		cond =
			$and: [
			
				{ completed: true}
				{ $or: [
						{ownedBy: req.user.username},{createdBy: req.user.username}]	
				}
			]				
	###
	if !_.isUndefined(dateEnd)
		cond =
			or: [
				{
					dateEnd:  {
						'$lte': dateEnd
					}
					completed: false
					ownedBy: req.user.username 
				}
				{
					dateEnd: null
					completed: false
					ownedBy: req.user.username
				}
			]
	
	if !_.isUndefined(completed)
		cond =
			{
				completed: true
				ownedBy: req.user.username
			}
	###	 
	
	#sails.log "cond: " + JSON.stringify cond 
	req.options.criteria = req.options.criteria || {}
	#req.options.criteria.blacklist = req.options.criteria.blacklist || [ 'limit', 'skip', 'sort', 'populate', 'to', 'toDate', 'page', 'per_page']
	req.options.criteria.blacklist = req.options.criteria.blacklist || [ 'populate', 'to', 'toDate', 'page', 'per_page']
	req.options.where = req.options.where || {}
	_.extend req.options.where, cond
	
	next()