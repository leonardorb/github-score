fs = require 'fs'
path = require 'path'
Mocha = require 'mocha'
Chai = require 'chai'

mocha = new Mocha ui: 'bdd', reporter: 'spec'
global.expect = Chai.expect

fs.readdirSync('test').filter((file) ->
  file.substr(-3) is '.js'
).forEach (file) -> mocha.addFile path.join 'test', file

mocha.run()