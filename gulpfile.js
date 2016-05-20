'use strict';

var config = require('./config/gulp.json')
var env = process.env.RAILS_ENV

config.outputDir = config.outputRoot + config.outputSubDir
if(!env || env == 'development' || env == 'test') {
  config.nonRevOutputDir = config.outputDir
  config.rev = false
  config.compress = false
} else {
  config.nonRevOutputDir = config.tmpDir
  config.revOutputDir = config.outputDir
  config.rev = true
  config.compress = true
}
Object.freeze(config)

module.exports = config
var _ = require('lodash')
var babelify = require('babelify')
var browserify = require('browserify')
var connect = require('gulp-connect')
var glob = require('glob')
var gulp = require('gulp')
var requireDir = require('require-dir')
var runSequence = require('run-sequence')
var sourcemaps = require('gulp-sourcemaps')
var uglify = require('gulp-uglify')
var vinylBuffer = require('vinyl-buffer')
var vinylSource = require('vinyl-source-stream')

var config = require('./lib/tasks/gulp/config')

requireDir('./lib/tasks/gulp')

function seq(task) {
  var runner = _.partial(runSequence, task)
  return function() {
    if(config.rev) {
      runner('version-assets', 'translate-versioned-assets')
    } else {
      runner()
    }
  }
}

gulp.task('default', function(callback) {
  return seq(['js'], callback)()
})

gulp.task('server', function() {
  connect.server({
    root: [config.outputRoot],
    port: 4857,
    livereload: false,
  })
})

gulp.task('watch', ['server'], function() {
  gulp.watch(['app/assets/javascripts/**/*'], seq('js-app'))
  gulp.watch(['app/assets/stylesheets/**/*'], seq('css'))
  gulp.watch(['app/assets/images/**/*'], seq('images'))
})

gulp.task('version-assets', function() {
  return gulp.src([
      config.nonRevOutputDir + '/**/*',
      '!' + config.nonRevOutputDir + '/**/*map',
    ])
    .pipe(rev())
    .pipe(gulp.dest(config.revOutputDir))
    .pipe(rev.manifest())
    .pipe(gulp.dest(config.revOutputDir))
})

gulp.task('translate-versioned-assets', function() {
  return gulp.src(config.revOutputDir + '/**/*.css')
    .pipe(fingerprint(config.revOutputDir + '/rev-manifest.json', {
      base: config.outputSubDir,
      prefix: '/' + config.outputSubDir,
    }))
    .pipe(gulp.dest(config.revOutputDir))
})

gulp.task('images', function() {
  return gulp.src(config.images.src)
    .pipe(gulp.dest(config.nonRevOutputDir))
})

gulp.task('css', function() {
  return gulp.src(config.css.src)
    .pipe(sourcemaps.init())
    .pipe(sass(config.css.sassOptions))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(config.nonRevOutputDir))
})
