GitHub = require '../src/assets/js/github'

describe 'GitHub', ->
  github = new GitHub()

  beforeEach (done) ->
    done()

  describe 'constructor', ->
    it 'should have a base URL to interact with GitHub', ->
      expect(github).to.have.property 'baseURL'

    it 'should have a base URL pointing to GitHub', ->
      expect(github.baseURL).to.equal 'https://www.github.com'

    it 'should have a Contributions rank factor', ->
      expect(github).to.have.property 'contributionsImportance'

    it 'should have a Contributions factor with 1 point of influence in the rank', ->
      expect(github.contributionsImportance).to.equal 1

    it 'should have a Contributions Interval factor', ->
      expect(github).to.have.property 'contributionsInterval'

    it 'should have a Contributions Interval factor as 365 (Perfect year interval)', ->
      expect(github.contributionsInterval).to.equal 365

    it 'should have a Longest Streak rank factor', ->
      expect(github).to.have.property 'longestStreakImportance'

    it 'should have a Longest Streak factor with 3.5 points of influence in the rank', ->
      expect(github.longestStreakImportance).to.equal 3.5

    it 'should have a Current Streak rank factor', ->
      expect(github).to.have.property 'currentStreakImportance'

    it 'should have a Current Streak factor with 7.25 points of influence in the rank', ->
      expect(github.currentStreakImportance).to.equal 7.25

    it 'should have a Followers rank factor', ->
      expect(github).to.have.property 'followersFactor'

    it 'should have a Followers factor with 0.00015 points of influence in the rank', ->
      expect(github.followersFactor).to.equal 0.00015

    it 'should have an initial Score Report', ->
      expect(github).to.have.property 'scoreReport'

    it 'should have an initial Score Report with a base structure', ->
      expect(github.scoreReport).to.equal '\n'

  describe 'getURLData', ->
    it 'should return null when a user does not exist on GitHub', (done) ->
      user = 'thisuserdoesnotexistongithub'
      github.getURLData(user, ($) ->
        expect($).to.not.be.nil
        done()
      )

    it 'should return the scraped data when a user exist on GitHub', (done) ->
      user = 'leonardorb'
      github.getURLData(user, ($) ->
        expect(typeof $).to.equal 'function'
        done()
      )

  describe 'reportLineFollowers', ->
    describe 'for followers < 2 and >= 0', ->
      it 'should generate a followers report line', ->
        reportLineFollowers = github.reportLineFollowers 1
        expect(reportLineFollowers).to.equal '1 follower | '
    describe 'for followers >= 2 and < 1000', ->
      it 'should generate a followers report line', ->
        reportLineFollowers = github.reportLineFollowers 450
        expect(reportLineFollowers).to.equal '450 followers | '
    describe 'for followers >= 1000', ->
      it 'should generate a followers report line', ->
        reportLineFollowers = github.reportLineFollowers 1200
        expect(reportLineFollowers).to.equal '1200+ followers | '

  describe 'reportLineContributions', ->
    describe 'for days < 2 and >= 0', ->
      it 'should generate a contributions report line', ->
        reportLineContributions = github.reportLineContributions 0
        expect(reportLineContributions).to.equal '0 contribution\n'
    describe 'for days >= 2', ->
      it 'should generate a contributions report line', ->
        reportLineContributions = github.reportLineContributions 55
        expect(reportLineContributions).to.equal '55 contributions\n'

  describe 'reportLineLongestStreak', ->
    describe 'for days < 2 and >= 0', ->
      it 'should generate a longest streak report line', ->
        reportLineLongestStreak = github.reportLineLongestStreak 1
        expect(reportLineLongestStreak).to.equal 'Longest streak: 1 day | '
    describe 'for days >= 2', ->
      it 'should generate a longest streak report line', ->
        reportLineLongestStreak = github.reportLineLongestStreak 3
        expect(reportLineLongestStreak).to.equal 'Longest streak: 3 days | '

  describe 'reportLineCurrentStreak', ->
    describe 'for days < 2 and >= 0', ->
      it 'should generate a current streak report line', ->
        reportLineCurrentStreak = github.reportLineCurrentStreak 1
        expect(reportLineCurrentStreak).to.equal 'Current streak: 1 day\n'
    describe 'for days >= 2', ->
      it 'should generate a current streak report line', ->
        reportLineCurrentStreak = github.reportLineCurrentStreak 3
        expect(reportLineCurrentStreak).to.equal 'Current streak: 3 days\n'

  describe 'reportLineScore', ->
    it 'should generate a score report line', ->
      reportLineScore = github.reportLineScore 100
      expect(reportLineScore).to.equal '# 100 points #'

