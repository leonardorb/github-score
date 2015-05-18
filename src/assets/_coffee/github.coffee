cheerio = require 'cheerio'
_ = require 'lodash'
request = require 'request'

class GitHub
  constructor: ->
    @baseURL = 'https://www.github.com'
    @contributionsImportance = 1
    # assuming that we always have a perfect year here
    @contributionsInterval = 365
    @longestStreakImportance = 3.5
    @currentStreakImportance = 7.25
    @followersFactor = 0.00015
    @scoreReport = '\n'

  generateScoreReport: (users, cb) ->
    [self, _users, _cb] = [@, users, cb]
    @generateUsersData 0, _users, (usersData) ->
      _.each usersData, (user, count) ->
        _count = count + 1
        self.reportLineUsername user.username, _count, (lineUsername) ->
          _lineUsername = lineUsername
          self.reportLineFollowers user.followers, (lineFollowers) ->
            _lineFollowers = lineFollowers
            self.reportLineContributions user.contributions, (lineContributions) ->
              _lineContributions = lineContributions
              self.reportLineLongestStreak user.longestStreak, (lineLongestStreak) ->
                _lineLongestStreak = lineLongestStreak
                self.reportLineCurrentStreak user.currentStreak, (lineCurrentStreak) ->
                  _lineCurrentStreak = lineCurrentStreak
                  self.reportLineScore user.score, (lineScore) ->
                    _lineScore = lineScore
                    self.scoreReport = self.scoreReport + _lineUsername + _lineFollowers + _lineContributions + _lineLongestStreak + _lineCurrentStreak + _lineScore + '\n\n'

      _cb self.scoreReport

  generateUsersData: (index, users, cb, usersData = []) ->
    [self, _index, _users, _cb] = [@, index, users, cb]
    @getURLData _users[index], ($) ->
      _$ = $
      self.getNumberOfFollowers _$, (followers) ->
        _followers = followers
        self.getNumberOfContributions _$, (contributions) ->
          _contributions = contributions
          self.getLongestStreak _$, (longestStreak) ->
            _longestStreak = longestStreak
            self.getCurrentStreak _$, (currentStreak) ->
              _currentStreak = currentStreak

              userData = {}
              userData.username = _users[index]
              userData.followers = _followers
              userData.contributions = _contributions
              userData.longestStreak = _longestStreak
              userData.currentStreak = _currentStreak
              usersData.push userData

              self.generateUserScore userData, (score) ->
                _score = score
                userData.score = _score
                index++
                if index is users.length
                  usersData = (_.sortBy usersData, (user) -> +user.score).reverse()
                  _cb usersData
                else
                  self.generateUsersData index, _users, _cb, usersData

  generateUserScore: (user, cb = ->) ->
    [_user, _cb] = [user, cb]
    contributionsScore = @generateContributionsScore _user.contributions
    longestStreakScore = @generateLongestStreakScore _user.longestStreak
    currentStreakScore = @generateCurrentStreakScore _user.currentStreak
    followersFactorScore = @generateUserFollowersFactor _user
    fullScore = (parseFloat((contributionsScore + longestStreakScore + currentStreakScore) * followersFactorScore)).toFixed 2
    _cb fullScore

  generateContributionsScore: (contributions) ->
    _contributions = contributions
    +(@contributionsImportance * _contributions).toFixed 2

  generateLongestStreakScore: (longestStreak) ->
    _longestStreak = longestStreak
    +(@longestStreakImportance * _longestStreak).toFixed 2

  generateCurrentStreakScore: (currentStreak) ->
    _currentStreak = currentStreak
    +(@currentStreakImportance * _currentStreak).toFixed 2

  generateAverageContributionsIndex: (contributions) ->
    _contributions = contributions
    # using the year interval here
    (_contributions/@contributionsInterval) + 1

  generateUserFollowersFactor: (user) ->
    _user = user
    # using the year interval here
    averageContributionsIndex = @generateAverageContributionsIndex _user.contributions
    userFollowersFactor = (averageContributionsIndex * (user.followers * @followersFactor)) + 1

  getURLData: (user, cb = ->) ->
    [self, _user, _cb] = [@, user, cb]
    userPath = @baseURL + '/' + _user
    request userPath, (error, response, body) ->
      $ = cheerio.load body
      if $('#parallax_error_text')[0]?
        console.log "ERROR: user '#{_user}' does not exist on GitHub."
      else
        _cb $

  getNumberOfFollowers: ($, cb = ->) ->
    [_$, _cb] = [$, cb]
    followers = _$(_$('.vcard-stat-count')[0]).text()
    if followers.indexOf('k') is -1
      followers = parseInt followers
    else
      numberRegex = /(.*)k/
      followers = (followers.match(numberRegex)[1])*1000
    _cb followers

  getNumberOfContributions: ($, cb = ->) ->
    [_$, _cb] = [$, cb]
    contributionsText = _$(_$('.contrib-number')[0]).text().replace ',',''
    numberRegex = /\d+/
    contributions = parseInt contributionsText.match(numberRegex)[0]
    _cb contributions

  getLongestStreak: ($, cb = ->) ->
    [_$, _cb] = [$, cb]
    streakText = _$(_$('.contrib-number')[1]).text()
    numberRegex = /\d+/
    streak = parseInt streakText.match(numberRegex)[0]
    _cb streak

  getCurrentStreak: ($, cb = ->) ->
    [_$, _cb] = [$, cb]
    streakText = _$(_$('.contrib-number')[2]).text()
    numberRegex = /\d+/
    streak = parseInt streakText.match(numberRegex)[0]
    _cb streak

  reportLineUsername: (username, count, cb = ->) ->
    [_username, _cb] = [username, cb]
    _cb '[' + count + '] - ' + _username.toUpperCase() + '\n'

  reportLineFollowers: (followers, cb = ->) ->
    [_followers, _cb] = [followers, cb]
    if _followers > 1
      if _followers >= 1000 then _followers = _followers + '+ followers | ' else _followers = _followers + ' followers | '
    else
      _followers = _followers + ' follower\n'
    _cb _followers

  reportLineContributions: (contributions, cb = ->) ->
    [_contributions, _cb] = [contributions, cb]
    if _contributions > 1 then _contributions = _contributions + ' contributions\n' else _contributions = _contributions + ' contribution\n'
    _cb _contributions

  reportLineLongestStreak: (longestStreak, cb = ->) ->
    [_longestStreak, _cb] = [longestStreak, cb]
    _preStreak = 'Longest streak: '
    if _longestStreak > 1 then _longestStreak = _longestStreak + ' days | ' else _longestStreak = _longestStreak + ' day | '
    _cb _preStreak + _longestStreak

  reportLineCurrentStreak: (currentStreak, cb = ->) ->
    [_currentStreak, _cb] = [currentStreak, cb]
    _preStreak = 'Current streak: '
    if _currentStreak > 1 then _currentStreak = _currentStreak + ' days\n' else _currentStreak = _currentStreak + ' day\n'
    _cb _preStreak + _currentStreak

  reportLineScore: (score, cb = ->) ->
    [_score, _cb] = [score, cb]
    _cb '# ' + _score + ' points #'

module.exports = GitHub