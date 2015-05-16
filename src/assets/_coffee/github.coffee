cheerio = require 'cheerio'
_ = require 'lodash'
request = require 'request'

class GitHub
  constructor: ->
    @baseURL = 'https://www.github.com'
    @followersImportance = 2.75
    @contributionsImportance = 1.25
    @scoreReport = '\n'

  generateScoreReport: (users, cb) ->
    [self, _users, _cb] = [@, users, cb]
    @generateUsersData 0, _users, (usersData) ->
      _.each usersData, (user) ->
        self.reportLineUsername user.username, (lineUsername) ->
          _lineUsername = lineUsername
          self.reportLineFollowers user.followers, (lineFollowers) ->
            _lineFollowers = lineFollowers
            self.reportLineContributions user.contributions, (lineContributions) ->
              _lineContributions = lineContributions
              self.reportLineScore user.score, (lineScore) ->
                _lineScore = lineScore
                self.scoreReport = self.scoreReport + _lineUsername + _lineFollowers + _lineContributions + _lineScore + '\n\n'

      _cb self.scoreReport

  generateUsersData: (index, users, cb, usersData = []) ->
    [self, _index, _users, _cb] = [@, index, users, cb]
    @getURLData _users[index], ($) ->
      _$ = $
      self.getNumberOfFollowers _$, (followers) ->
        _followers = followers
        self.getNumberOfContributions _$, (contributions) ->
          _contributions = contributions

          userData = {}
          userData.username = _users[index]
          userData.followers = _followers
          userData.contributions = _contributions
          usersData.push userData

          self.generateUserScore userData, (score) ->
            _score = score
            userData.score = _score
            index++
            if index is users.length
              usersData = _.sortBy(usersData, 'score').reverse()
              _cb usersData
            else
              self.generateUsersData index, _users, _cb, usersData

  generateUserScore: (user, cb = ->) ->
    [_user, _cb] = [user, cb]
    followersScore = +(@followersImportance * _user.followers).toFixed 2
    contributionsScore = +(@contributionsImportance * _user.contributions).toFixed 2
    fullScore = followersScore + contributionsScore
    _cb fullScore

  getURLData: (user, cb = ->) ->
    [self, _user, _cb] = [@, user, cb]
    userPath = @baseURL + '/' + _user
    request userPath, (error, response, body) ->
      $ = cheerio.load body
      _cb $

  getNumberOfFollowers: ($, cb = ->) ->
    [self, _$, _cb] = [@, $, cb]
    followers = parseInt _$(_$('.vcard-stat-count')[0]).text()
    _cb followers

  getNumberOfContributions: ($, cb = ->) ->
    [self, _$, _cb] = [@, $, cb]
    contributionsText = _$(_$('.contrib-number')[0]).text()
    numberRegex = /\d+/
    contributions = parseInt contributionsText.match(numberRegex)[0]
    _cb contributions

  reportLineUsername: (username, cb = ->) ->
    [_username, _cb] = [username, cb]
    _cb '=> ' + _username.toUpperCase() + '\n'

  reportLineFollowers: (followers, cb = ->) ->
    [_followers, _cb] = [followers, cb]
    if _followers > 1 then _followers = _followers + ' followers\n' else _followers = _followers + ' follower\n'
    _cb _followers

  reportLineContributions: (contributions, cb = ->) ->
    [_contributions, _cb] = [contributions, cb]
    if _contributions > 1 then _contributions = _contributions + ' contributions\n' else _contributions = _contributions + ' contribution\n'
    _cb _contributions

  reportLineScore: (score, cb = ->) ->
    [_score, _cb] = [score, cb]
    _cb '# ' + _score + ' points #'

module.exports = GitHub