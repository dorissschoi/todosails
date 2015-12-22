module.exports.bootstrap = (cb) ->
	
	schedule = require('node-schedule')
	Object.keys(sails.config.crontab).forEach (key) ->
		val = sails.config.crontab[key]
		schedule.scheduleJob key, val
		return
  	
	cb()
	return