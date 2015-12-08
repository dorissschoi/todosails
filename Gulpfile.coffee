argv = require('yargs').argv
gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'

bower = require 'bower'
concat = require 'gulp-concat'
sass = require 'gulp-sass'
minifyCss = require 'gulp-minify-css'
rename = require 'gulp-rename'
sh = require 'shelljs'
bower = require 'gulp-bower'
templateCache = require 'gulp-angular-templatecache'


paths = sass: ['./scss/**/*.scss']

gulp.task 'default', ['coffee', 'sass']

gulp.task 'sass', (done) ->
  gulp.src('./scss/ionic.app.scss')
    .pipe(sass())
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))


     

gulp.task 'coffee', ['template'],  ->
  browserify(entries: ['./www/js/index.coffee'])
  	.transform('coffeeify')
    .transform('debowerify')
    .bundle()
    .pipe(source('index.js'))
    .pipe(gulp.dest('./www/js/'))
  
gulp.task 'template', ->
  gulp.src('./www/templates/**/*.html')
  	.pipe(templateCache(root: 'templates', standalone: true))
  	.pipe(gulp.dest('./www/js/'))