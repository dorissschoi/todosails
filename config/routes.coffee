###
module.exports = 
	routes:
		'GET /api/todo':
			controller:		'TodoController'
			action:			'find'
			sort:			
				task:	'asc'
###				