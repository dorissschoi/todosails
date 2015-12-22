module.exports.crontab = '0 0 8 * * *': ->
#module.exports.crontab = '0 */2 * * * *': ->
  require('../crontab/dailydigest.coffee').run()
  return
