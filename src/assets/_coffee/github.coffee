cheerio = require 'cheerio'
#path = require 'path'
request = require 'request'

class GitHub
  constructor: ->
    @baseURL = 'https://www.github.com'

  generateScoreReport: (users, cb) ->
    [self, _users, _cb] = [@, users, cb]

    @generateUsersReport 0, _users, (fullReport) ->
      _cb fullReport

  generateUsersReport: (index, users, cb, fullReport = "\n\n") ->
    [self, _index, _users, _cb] = [@, index, users, cb]
    @getURLData users[index], ($) ->
      _$ = $
      self.getNumberOfFollowers _$, (followers) ->
        _followers = followers
        self.getNumberOfContributions _$, (contributions) ->
          _contributions = contributions
          txtReport = '=> ' + users[index].toUpperCase() + '\n'
          txtReport = txtReport + _followers
          if _followers > 1 then txtReport = txtReport + ' followers \n' else txtReport = txtReport + ' follower \n'
          txtReport = txtReport + _contributions
          if _contributions > 1 then txtReport = txtReport + ' contributions \n\n' else txtReport = txtReport + ' contribution \n\n'
          fullReport = fullReport + txtReport

          index++
          if index is users.length then _cb fullReport else self.generateUsersReport index, _users, _cb, fullReport

  getURLData: (user, cb) ->
    [self, _user, _cb] = [@, user, cb]
    userPath = @baseURL + '/' + _user
    request userPath, (error, response, body) ->
      $ = cheerio.load body
      _cb $

  getNumberOfFollowers: ($, cb = ->) ->
    [self, _$, _cb] = [@, $, cb]
    _cb _$(_$('.vcard-stat-count')[0]).text()

  getNumberOfContributions: ($, cb = ->) ->
    [self, _$, _cb] = [@, $, cb]
    contributionsText = _$(_$('.contrib-number')[0]).text()
    numberRegex = /\d+/
    contributions = contributionsText.match(numberRegex)[0]
    _cb contributions

module.exports = GitHub