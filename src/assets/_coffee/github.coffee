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
        lineUsername = self.reportLineUsername user, _count
        lineFollowers = self.reportLineFollowers user.followers
        lineContributions = self.reportLineContributions user.contributions
        lineLongestStreak = self.reportLineLongestStreak user.longestStreak
        lineCurrentStreak = self.reportLineCurrentStreak user.currentStreak
        lineScore = self.reportLineScore user.score
        self.scoreReport = self.scoreReport + lineUsername + lineFollowers + lineContributions + lineLongestStreak + lineCurrentStreak + lineScore + '\n\n'

      _cb self.scoreReport

  generateUsersData: (index, users, cb, usersData = []) ->
    [self, _index, _users, _cb] = [@, index, users, cb]
    @getURLData _users[index], ($) ->
      _$ = $
      followers = self.getNumberOfFollowers _$
      contributions = self.getNumberOfContributions _$
      longestStreak = self.getLongestStreak _$
      currentStreak = self.getCurrentStreak _$

      userData = {}
      userData.username = _users[index]
      userData.followers = followers
      userData.contributions = contributions
      userData.longestStreak = longestStreak
      userData.currentStreak = currentStreak
      usersData.push userData

      score = self.generateUserScore userData
      userData.score = score
      index++
      if index is users.length
        usersData = (_.sortBy usersData, (user) -> +user.score).reverse()
        _cb usersData
      else
        self.generateUsersData index, _users, _cb, usersData

  generateUserScore: (user) ->
    _user = user
    contributionsScore = @generateContributionsScore _user.contributions
    longestStreakScore = @generateLongestStreakScore _user.longestStreak
    currentStreakScore = @generateCurrentStreakScore _user.currentStreak
    followersFactorScore = @generateUserFollowersFactor _user
    fullScore = (parseFloat((contributionsScore + longestStreakScore + currentStreakScore) * followersFactorScore)).toFixed 2
    fullScore

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

  getNumberOfFollowers: ($) ->
    _$ = $
    followers = _$(_$('.vcard-stat-count')[0]).text()
    if followers.indexOf('k') is -1
      followers = parseInt followers
    else
      numberRegex = /(.*)k/
      followers = (followers.match(numberRegex)[1])*1000
    followers

  getNumberOfContributions: ($) ->
    _$ = $
    contributionsText = _$(_$('.contrib-number')[0]).text().replace ',',''
    numberRegex = /\d+/
    contributions = parseInt contributionsText.match(numberRegex)[0]
    contributions

  getLongestStreak: ($) ->
    _$ = $
    streakText = _$(_$('.contrib-number')[1]).text()
    numberRegex = /\d+/
    streak = parseInt streakText.match(numberRegex)[0]
    streak

  getCurrentStreak: ($) ->
    _$ = $
    streakText = _$(_$('.contrib-number')[2]).text()
    numberRegex = /\d+/
    streak = parseInt streakText.match(numberRegex)[0]
    streak

  reportLineUsername: (user, count) ->
    [_user, _count] = [user, count]
    '[' + _count + '] - ' + _user.username.toUpperCase() + '\n'

  reportLineFollowers: (followers) ->
    [_followers] = [followers]
    if _followers > 1
      if _followers >= 1000 then _followers = _followers + '+ followers | ' else _followers = _followers + ' followers | '
    else
      _followers = _followers + ' follower\n'
    _followers

  reportLineContributions: (contributions) ->
    [_contributions] = [contributions]
    if _contributions > 1 then _contributions = _contributions + ' contributions\n' else _contributions = _contributions + ' contribution\n'
    _contributions

  reportLineLongestStreak: (longestStreak) ->
    [_longestStreak] = [longestStreak]
    _preStreak = 'Longest streak: '
    if _longestStreak > 1 then _longestStreak = _longestStreak + ' days | ' else _longestStreak = _longestStreak + ' day | '
    _preStreak + _longestStreak

  reportLineCurrentStreak: (currentStreak) ->
    [_currentStreak] = [currentStreak]
    _preStreak = 'Current streak: '
    if _currentStreak > 1 then _currentStreak = _currentStreak + ' days\n' else _currentStreak = _currentStreak + ' day\n'
    _preStreak + _currentStreak

  reportLineScore: (score) ->
    [_score] = [score]
    '# ' + _score + ' points #'

module.exports = GitHub