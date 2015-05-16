(function() {
  var GitHub, cheerio, request;

  cheerio = require('cheerio');

  request = require('request');

  GitHub = (function() {
    function GitHub() {
      this.baseURL = 'https://www.github.com';
    }

    GitHub.prototype.generateScoreReport = function(users, cb) {
      var _cb, _users, ref, self;
      ref = [this, users, cb], self = ref[0], _users = ref[1], _cb = ref[2];
      return this.generateUsersReport(0, _users, function(fullReport) {
        return _cb(fullReport);
      });
    };

    GitHub.prototype.generateUsersReport = function(index, users, cb, fullReport) {
      var _cb, _index, _users, ref, self;
      if (fullReport == null) {
        fullReport = "\n\n";
      }
      ref = [this, index, users, cb], self = ref[0], _index = ref[1], _users = ref[2], _cb = ref[3];
      return this.getURLData(users[index], function($) {
        var _$;
        _$ = $;
        return self.getNumberOfFollowers(_$, function(followers) {
          var _followers;
          _followers = followers;
          return self.getNumberOfContributions(_$, function(contributions) {
            var _contributions, txtReport;
            _contributions = contributions;
            txtReport = '=> ' + users[index].toUpperCase() + '\n';
            txtReport = txtReport + _followers;
            if (_followers > 1) {
              txtReport = txtReport + ' followers \n';
            } else {
              txtReport = txtReport + ' follower \n';
            }
            txtReport = txtReport + _contributions;
            if (_contributions > 1) {
              txtReport = txtReport + ' contributions \n\n';
            } else {
              txtReport = txtReport + ' contribution \n\n';
            }
            fullReport = fullReport + txtReport;
            index++;
            if (index === users.length) {
              return _cb(fullReport);
            } else {
              return self.generateUsersReport(index, _users, _cb, fullReport);
            }
          });
        });
      });
    };

    GitHub.prototype.getURLData = function(user, cb) {
      var _cb, _user, ref, self, userPath;
      ref = [this, user, cb], self = ref[0], _user = ref[1], _cb = ref[2];
      userPath = this.baseURL + '/' + _user;
      return request(userPath, function(error, response, body) {
        var $;
        $ = cheerio.load(body);
        return _cb($);
      });
    };

    GitHub.prototype.getNumberOfFollowers = function($, cb) {
      var _$, _cb, ref, self;
      if (cb == null) {
        cb = function() {};
      }
      ref = [this, $, cb], self = ref[0], _$ = ref[1], _cb = ref[2];
      return _cb(_$(_$('.vcard-stat-count')[0]).text());
    };

    GitHub.prototype.getNumberOfContributions = function($, cb) {
      var _$, _cb, contributions, contributionsText, numberRegex, ref, self;
      if (cb == null) {
        cb = function() {};
      }
      ref = [this, $, cb], self = ref[0], _$ = ref[1], _cb = ref[2];
      contributionsText = _$(_$('.contrib-number')[0]).text();
      numberRegex = /\d+/;
      contributions = contributionsText.match(numberRegex)[0];
      return _cb(contributions);
    };

    return GitHub;

  })();

  module.exports = GitHub;

}).call(this);
