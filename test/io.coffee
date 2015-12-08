env = require './env.coffee'
require '../index.js'
require './iomodel.coffee'
_ = require 'lodash'

angular.module 'app', ['util.auth', 'starter.model']
	.run (authService) ->
		authService.login env.oauth2.io
		
	.controller 'UsersCtrl', ($scope, resource) ->
		users = new resource.Users()
		users.$fetch()
			.catch alert
		_.extend $scope,
			collection: users
			loadMore: ->
				users.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert