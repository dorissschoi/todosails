
module.exports = 
	policies:
		TodoController:
			'*':	false
			find:	['isAuth', 'todo/setTask']	
			create: ['isAuth', 'setCreatedBy' , 'setOwner']
			update: ['isAuth', 'isOwnerOrCreatedBy']
			destroy: ['isAuth', 'isCreatedBy']
