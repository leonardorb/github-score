GitHub = require './github'
_ = require 'lodash'

gh = new GitHub
users = process.argv.slice 2

gh.generateScoreReport users, (report) ->
  console.log report