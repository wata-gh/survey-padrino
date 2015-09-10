gulp        = require 'gulp'
bower       = require 'main-bower-files'
gulpFilter  = require 'gulp-filter'
plumber     = require 'gulp-plumber'
concat      = require 'gulp-concat'
less        = require 'gulp-less'
sass        = require 'gulp-sass'
coffee      = require 'gulp-coffee'
urlAdjuster = require 'gulp-css-url-adjuster'

gulp.task 'bower', ->
  jsFilter = gulpFilter '**/*.js'
  lessFilter = gulpFilter '**/*.less'
  gulp.src bower()
    .pipe jsFilter
    .pipe plumber()
    .pipe concat('vendor.js')
    .pipe gulp.dest('./public/javascripts')
  gulp.src bower()
    .pipe lessFilter
    .pipe less()
    .pipe plumber()
    .pipe concat('vendor.css')
    .pipe urlAdjuster({
      prepend: '/s/',
    })
    .pipe gulp.dest('./public/stylesheets')

gulp.task 'sass', ->
  gulp.src './sass/**/*.scss'
    .pipe sass().on('error', sass.logError)
    .pipe gulp.dest('./public/stylesheets')

gulp.task 'coffee', ->
  gulp.src './coffee/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest('./public/javascripts')

gulp.task 'watch', ->
  gulp.watch 'bower.json', ['bower']
  gulp.watch 'sass/**/*.scss', ['sass']
  gulp.watch 'coffee/**/*.coffee', ['coffee']
