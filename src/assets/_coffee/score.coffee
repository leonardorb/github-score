GitHub = require './github'

gh = new GitHub
users = process.argv.slice 2

if users.length > 0
  gh.generateScoreReport users, (report) ->
    console.log report
else
  console.log 'We need usernames to generate the score!'