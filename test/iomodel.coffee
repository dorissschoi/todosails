env = require './env.coffee'
require 'PageableAR'
_ = require 'lodash'
		
urlRoot = (model, url, root = env.server.io.urlRoot) ->
	if model.transport() == 'io' then "#{url}" else "#{root}#{url}"
		
angular.module('starter.model', ['ionic', 'PageableAR'])
	
	.factory 'resource', ($rootScope, pageableAR, $http) ->
		
		pageableAR.setTransport(pageableAR.Model.iosync)
		
		class User extends pageableAR.Model
			$urlRoot: ->
				urlRoot(@, "/api/user")
						
		class Users extends pageableAR.PageableCollection
			$urlRoot: ->
				urlRoot(@, "/api/user")
			
			model: User
				
		User:			User
		Users:			Users	