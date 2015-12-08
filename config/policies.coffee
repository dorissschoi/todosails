
module.exports = 
	policies:
		TodoController:
			'*':	false
			find:	['isAuth', 'todo/setTask']	
			create: ['isAuth', 'setOwner' ]
			update: ['isAuth']
			destroy: ['isAuth']
