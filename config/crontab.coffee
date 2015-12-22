module.exports.crontab = '0 45 11 * * *': ->
  require('../crontab/dailydigest.coffee').run()
  return
