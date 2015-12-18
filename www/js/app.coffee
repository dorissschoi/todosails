env = require './env.coffee'

module = angular.module('starter', ['ionic', 'util.auth', 'starter.controller', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngTouch', 'ngAnimate', 'ionic-datepicker', 'ionic-timepicker', 'pascalprecht.translate', 'locale'])

module
.run (authService) ->
	authService.login env.oauth2.opts
        
.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
	$ionicPlatform.ready ->
		if (window.cordova && window.cordova.plugins.Keyboard)
			cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
		if (window.StatusBar)
			StatusBar.styleDefault()
					
.config ($stateProvider, $urlRouterProvider, $translateProvider) ->

	$stateProvider.state 'app',
		url: ""
		abstract: true
		templateUrl: "templates/menu.html"

	$stateProvider.state 'app.createTodo',
		url: "/todo/create"
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/todo/create.html"
				controller: 'TodoCtrl'
	
	$stateProvider.state 'app.readTodo',
		url: "/todo/read"
		params: SelectedTodo: null, myTodoCol: null, backpage: null
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/todo/read.html"
				#controller: 'TodoReadCtrl'
				controller: 'TodoEditCtrl'
				
	$stateProvider.state 'app.editTodo',
		url: "/todo/edit"
		params: SelectedTodo: null, backpage: null
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/todo/edit.html"
				controller: 'TodoEditCtrl'				

	# My todo day
	$stateProvider.state 'app.weekList',
		url: "/todo/weekList"
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/todo/weeklist.html"
				controller: 'WeekListCtrl'

	# My todo completed
	$stateProvider.state 'app.completedList',
		url: "/todo/completedList"
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/todo/completedlist.html"
				controller: 'CompletedListCtrl'									
	
	$urlRouterProvider.otherwise('/todo/weekList')				
	#$urlRouterProvider.otherwise('/todo/completedList')
	#$urlRouterProvider.otherwise('/todo/mytodopage')
	
	