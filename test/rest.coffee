env = require './env.coffee'
require '../index.js'
require './restmodel.coffee'
_ = require 'lodash'

angular.module 'app', ['util.auth', 'starter.model']
	.run (authService) ->
		authService.login env.oauth2.rest
		
	.controller 'UsersCtrl', ($scope, resource) ->
		users = new resource.Users()
		users.$fetch()
			.catch alert
		_.extend $scope,
			collection: users
			loadMore: ->
				users.$fetch(params: page: (users.state.skip / users.state.limit + 1))
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert