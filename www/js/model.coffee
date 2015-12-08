env = require './env.coffee'

iconUrl = (type) ->
	icon = 
		"text/directory":				"img/dir.png"
		"text/plain":					"img/txt.png"
		"text/html":					"img/html.png"
		"application/javascript":		"img/js.png"
		"application/octet-stream":		"img/dat.png"
		"application/pdf":				"img/pdf.png"
		"application/excel":			"img/xls.png"
		"application/x-zip-compressed":	"img/zip.png"
		"application/msword":			"img/doc.png"
		"image/png":					"img/png.png"
		"image/jpeg":					"img/jpg.png"
	return if type of icon then icon[type] else "img/unknown.png"
		
model = (ActiveRecord, $rootScope, platform) ->
	
	class Model extends ActiveRecord
		constructor: (attrs = {}, opts = {}) ->
			@$initialize(attrs, opts)
			
		$changedAttributes: (diff) ->
			_.omit super(diff), '$$hashKey' 
		
		$save: (values, opts) ->
			if @$hasChanged()
				super(values, opts)
			else
				return new Promise (fulfill, reject) ->
					fulfill @
		
	class Collection extends Model
		constructor: (@models = [], opts = {}) ->
			super({}, opts)
			@length = @models.length
					
		add: (models, opts = {}) ->
			singular = not _.isArray(models)
			if singular and models?
				models = [models]
			_.each models, (item) =>
				if not @contains item 
					@models.push item
					@length++
				
		remove: (models, opts = {}) ->
			singular = not _.isArray(models)
			if singular and models?
				models = [models]
			_.each models, (model) =>
				model.$destroy().then =>
					@models = _.filter @models, (item) =>
						item[@$idAttribute] != model[@$idAttribute]
			@length = @models.length
				
		contains: (model) ->
			cond = (a, b) ->
				a == b
			if typeof model == 'object'
				cond = (a, b) =>
					a[@$idAttribute] == b[@$idAttribute]
			ret = _.find @models, (elem) =>
				cond(model, elem) 
			return ret?	
		
		$fetch: (opts = {}) ->
			return new Promise (fulfill, reject) =>
				@$sync('read', @, opts)
					.then (res) =>
						data = @$parse(res.data, opts)
						if _.isArray data.results
							@add data.results
							fulfill @
						else
							reject 'Not a valid response type'
					.catch reject
		
	class PageableCollection extends Collection
		constructor: (models = [], opts = {}) ->
			@state =
				count:		0
				page:		0
				per_page:	10
				total_page:	0
			super(models, opts)
				
		###
		opts:
			params:
				page:		page no to be fetched (first page = 1)
				per_page:	no of records per page
		###
		$fetch: (opts = {}) ->
			opts.params = opts.params || {}
			opts.params.page = @state.page + 1
			opts.params.per_page = opts.params.per_page || @state.per_page
			return new Promise (fulfill, reject) =>
				@$sync('read', @, opts)
					.then (res) =>
						data = @$parse(res.data, opts)
						if data.count? and data.results?
							@add data.results
							@models = _.union(@models, data.results)
							@state = _.extend @state,
								count:		data.count
								page:		opts.params.page
								per_page:	opts.params.per_page
								total_page:	Math.ceil(data.count / opts.params.per_page)
							fulfill @
						else
							reject 'Not a valid response type'
					.catch reject
		
	class User extends Model
		$idAttribute: 'username'
		
		$urlRoot: "#{env.authUrl}/org/api/users/"
			
		@me: ->
			(new User(username: 'me/')).$fetch()	
			
	class Permission extends Model
		$idAttribute: '_id'
		
		$urlRoot: "#{env.serverUrl()}/api/permission"
		
	class Acl extends PageableCollection
		$idAttribute: '_id'
	
		$urlRoot: "#{env.serverUrl()}/api/permission"
		
		$parse: (res, opts) ->
			_.each res.results, (value, key) =>
				res.results[key] = new Permission res.results[key]
			return res
		
	class UserGrps extends Collection
		$idAttribute: 'group'
		
		$urlRoot: "#{env.imUrl()}/api/roster"
		
		$parse: (res, opts) ->
			ret = []
			_.each res, (rosteritem) ->
				_.each rosteritem.groups, (group) ->
					if group not in ret
						ret.push group
			return ret
			
		select: (group) ->
			_.each @models, (item) ->
				item.selected = item.group == group
				
		selected: ->
			_.findWhere @models, selected: true
			
		toString: ->
			@selected()?.group
			
	class FileGrps extends Collection
		$idAttribute: 'group'
		
		$urlRoot: "#{env.serverUrl()}/api/tag"
		
		select: (group) ->
			_.each @models, (item) ->
				item.selected = item.group == group
				
		selected: ->
			_.findWhere @models, selected: true
			
		toString: ->
			@selected()?.group


	class Todo extends Model
		$idAttribute: '_id'
		
		$urlRoot: "#{env.serverUrl()}/api/todo/"
		#$urlRoot: "http://localhost:1337/todo/api/todo/"
		
		
		$save: (values, opts) ->
			if @$hasChanged()
				super(values, opts)
			else
				return new Promise (fulfill, reject) ->
					fulfill @		
		
	class MyTodoList extends PageableCollection
		$idAttribute: '_id'
	
		$urlRoot: "#{env.serverUrl()}/api/mytodopage"
		#$urlRoot: "http://localhost:1337/todo/api/todo/"
		
		
		$parseModel: (res, opts) ->
			if !_.isNull(res.dateEnd)
				res.dateEnd = new Date(Date.parse(res.dateEnd))
			return new Todo res
	
		
		$parse: (res, opts) ->
			_.each res.results, (value, key) =>
				#res.results[key] = new Todo res.results[key]
				res.results[key] = @$parseModel(res.results[key], opts)
			return res


	# UpcomingList
	class UpcomingList extends PageableCollection
		$idAttribute: '_id'
	
		$urlRoot: "#{env.serverUrl()}/api/myupcomingtodo"
		#$urlRoot: "http://localhost:1337/todo/api/todo/"
		
			
		$parseModel: (res, opts) ->
			if !_.isNull(res.dateEnd)
				res.dateEnd = new Date(Date.parse(res.dateEnd))
			return new Todo res
			
		$parse: (res, opts) ->
			_.each res.results, (value, key) =>
				res.results[key] = @$parseModel(res.results[key], opts)
			return res

	# TodayList
	class TodayList extends PageableCollection
		$idAttribute: '_id'
	
		$urlRoot: "#{env.serverUrl()}/api/todo"
		#$urlRoot: "http://localhost:1337/todo/api/todo/"
		
			
		$parseModel: (res, opts) ->
			if !_.isNull(res.dateEnd)
				res.dateEnd = new Date(Date.parse(res.dateEnd))
			return new Todo res
			
		$parse: (res, opts) ->
			_.each res.results, (value, key) =>
				res.results[key] = @$parseModel(res.results[key], opts)
			return res			

				
		
	Model:		Model
	Collection:	Collection
	User:		User
	File:		File
	Permission:	Permission
	Acl:		Acl
	UserGrps:	UserGrps
	FileGrps:	FileGrps
	Todo:		Todo
	MyTodoList:	MyTodoList
	UpcomingList:	UpcomingList
	TodayList:	TodayList
				
config = ->
	return
	
angular.module('starter.model', ['ionic', 'ActiveRecord']).config [config]

angular.module('starter.model').factory 'model', ['ActiveRecord', '$rootScope', 'platform', model]