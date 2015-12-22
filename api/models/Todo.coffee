				
module.exports =
	tableName:		'todos'
  
	schema: 		true
  
	attributes:
  
		task:
			type: 'string'
			required:	true

		location:
			type: 'string'

		project:
			type: 'string'

		notes:
			type: 'string'

		completed:
			type: 'boolean'
			defaultsTo: false

		dateEnd:
			type: 'datetime'
			defaultsTo: null

		createdBy:
			type: 'string'
			required:	true

		ownedBy:
			type: 'string'
			required:	true
				  
	afterCreate: (values, cb) ->
		MsgService.sendMsg(values)

		return cb null, values  