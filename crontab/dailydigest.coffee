			
module.exports = 
	run: () ->  
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
					MsgService.sendMsg(_.extend(task, {taskCount: _.size(tasklist)}))
			 		
	    	.catch (err) ->
	    		sails.log err
	    		
		return