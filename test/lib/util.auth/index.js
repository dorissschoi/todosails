var $, _;

$ = require('jquery');

$.deparam = require('jquery-deparam');

_ = require('lodash');

require('angular');

require('angular-animate');

require('angular-sanitize');

require('angular-ui-router');

require('ionic');

require('sails-auth');

angular.module('util.auth', ['ionic', 'http-auth-interceptor']).config(function($provide) {
  return $provide.decorator('authService', function($delegate, $http, $sailsSocket, $rootScope, $ionicModal) {
    var check, loginConfirmed, prompt, url;
    loginConfirmed = $delegate.loginConfirmed;
    $delegate.loginConfirmed = function(data, configUpdater) {
      if (data != null) {
        $http.defaults.headers.common.Authorization = "Bearer " + data.access_token;
        $sailsSocket.defaults.headers.common.Authorization = "Bearer " + data.access_token;
        return loginConfirmed(null, function(config) {
          config.headers = _.omit(config.headers, 'Authorization');
          return config;
        });
      }
    };
    url = function(opts) {
      return opts.authUrl + "?" + ($.param(_.pick(opts, 'client_id', 'scope', 'response_type')));
    };
    prompt = function(opts) {
      var template;
      template = "<ion-modal-view>\n	<ion-content>\n		<iframe src='" + (url(opts)) + "'>\n		</iframe>\n	</ion-content>\n</ion-modal-view>";
      $rootScope.loginModal = $ionicModal.fromTemplate(template);
      return $rootScope.loginModal.show();
    };
    check = function(url, close) {
      var data, err, path;
      if (url.match(/error|access_token/)) {
        path = new URL(url);
        data = $.deparam(/(?:[#\/]*)(.*)/.exec(path.hash)[1]);
        err = $.deparam(/\?*(.*)/.exec(path.search)[1]);
        if (err.error) {
          close();
          return $delegate.loginCancelled(null, err.error);
        } else {
          close();
          return $delegate.loginConfirmed(data);
        }
      }
    };
    window.addEventListener('message', function(event) {
      return check(event.data, function() {
        return $rootScope.loginModal.remove();
      });
    });
    $delegate.login = function(opts) {
      $rootScope.$on('event:auth-forbidden', function() {
        return prompt(opts);
      });
      return $rootScope.$on('event:auth-loginRequired', function() {
        return prompt(opts);
      });
    };
    return $delegate;
  });
});
