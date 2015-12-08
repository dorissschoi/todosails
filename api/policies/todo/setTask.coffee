actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

# add criteria for todo  
module.exports = (req, res, next) ->
	values = actionUtil.parseValues(req)
	dateEnd = values.toDate
	completed = values.completed

	if !_.isUndefined(dateEnd)
		cond =
			or: [
				{
					dateEnd:  {
						'$lte': dateEnd
					}
					completed: false
				}
				{
					dateEnd: null
					completed: false
				}
			]

	if !_.isUndefined(completed)
		cond =
			completed: true
	 
	req.options.criteria = req.options.criteria || {}
	req.options.criteria.blacklist = req.options.criteria.blacklist || [ 'limit', 'skip', 'sort', 'populate', 'to', 'toDate', 'page', 'per_page']
	req.options.where = req.options.where || {}
	_.extend req.options.where, cond
	
	next()