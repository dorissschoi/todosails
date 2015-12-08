$ = require 'jquery'
$.deparam = require 'jquery-deparam'
_ = require 'lodash'
require 'angular'
require 'angular-animate'
require 'angular-sanitize'
require 'angular-ui-router'
require 'ionic'
require 'sails-auth'

angular.module 'util.auth', ['ionic', 'http-auth-interceptor']

	.config ($provide) ->
		$provide.decorator 'authService', ($delegate, $http, $sailsSocket, $rootScope, $ionicModal) ->
			loginConfirmed = $delegate.loginConfirmed
			# set authorization header once oauth2 token is available
			$delegate.loginConfirmed = (data, configUpdater) ->
				if data?
					$http.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
					$sailsSocket.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
					loginConfirmed null, (config) ->
						config.headers = _.omit config.headers, 'Authorization'
						return config
				
			url = (opts) ->
				"#{opts.authUrl}?#{$.param(_.pick(opts, 'client_id', 'scope', 'response_type'))}"
				
			prompt = (opts) -> 
				template = """
					<ion-modal-view>
						<ion-content>
							<iframe src='#{url(opts)}'>
							</iframe>
						</ion-content>
					</ion-modal-view>
				"""
				$rootScope.loginModal = $ionicModal.fromTemplate template
				$rootScope.loginModal.show() 
			
			check = (url, close) ->
				if url.match(/error|access_token/)
					path = new URL(url)
					data = $.deparam /(?:[#\/]*)(.*)/.exec(path.hash)[1]	# remove leading / or #
					err = $.deparam /\?*(.*)/.exec(path.search)[1]			# remove leading ?
					if err.error
						close()
						$delegate.loginCancelled null, err.error
					else
						close()
						$delegate.loginConfirmed data
						
			window.addEventListener 'message', (event) ->
				check event.data, ->
					$rootScope.loginModal.remove()
			
			$delegate.login = (opts) ->
				$rootScope.$on 'event:auth-forbidden', ->
					prompt(opts)
						
				$rootScope.$on 'event:auth-loginRequired', ->
					prompt(opts)
				
			return $delegate