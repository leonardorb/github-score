gulp = require 'gulp'
gulpUtil = require 'gulp-util'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
path = require 'path'

sources =
  sass: 'src/assets/_sass/*.scss'
  coffee: 'src/assets/_coffee/*.coffee'
  specs: 'test/*.coffee'

destinations =
  css: 'src/assets/css'
  js: 'src/assets/js'
  specs: 'test'

gulp.task 'watch', ->
  if !process.env.TRAVIS?
    gulp.watch sources.coffee, ['coffee']
    gulp.watch sources.sass, ['sass']
    gulp.watch sources.specs, ['specs']

gulp.task 'coffee', ->
  gulp.src sources.coffee
    .pipe coffee().on 'error', gulpUtil.log
    .pipe gulp.dest destinations.js

gulp.task 'sass', ->
  gulp.src sources.sass
    .pipe sass().on 'error', gulpUtil.log
    .pipe gulp.dest destinations.css

gulp.task 'specs', ->
  gulp.src sources.specs
    .pipe coffee().on 'error', gulpUtil.log
    .pipe gulp.dest destinations.specs

gulp.task 'default', ['coffee', 'sass', 'specs', 'watch']
