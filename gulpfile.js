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

var _ = require('lodash')
var babelify = require('babelify')
var browserify = require('browserify')
var connect = require('gulp-connect')
var glob = require('glob')
var gulp = require('gulp')
var rev = require('gulp-rev')
var fingerprint = require('gulp-fingerprint')
var runSequence = require('run-sequence')
var sass = require('gulp-sass')
var sourcemaps = require('gulp-sourcemaps')
var uglify = require('gulp-uglify')
var vinylBuffer = require('vinyl-buffer')
var vinylSource = require('vinyl-source-stream')

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
  return seq(['js', 'css', 'images'], callback)()
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
  var imageOutputDir = config.nonRevOutputDir + 'images/'
  return gulp.src(config.images.src)
    .pipe(gulp.dest(imageOutputDir))
})

gulp.task('css', function() {
  return gulp.src(config.css.src)
    .pipe(sourcemaps.init())
    .pipe(sass(config.css.sassOptions))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(config.nonRevOutputDir))
})

function getNPMPackageIds() {
  var packageManifest = {};
  try {
    packageManifest = require('./package.json');
  } catch (e) {}
  var deps = Object.keys(packageManifest.dependencies) || []
  return deps
}

function bundle(browserifyPack, name) {
  var p = browserifyPack.bundle()
    .pipe(vinylSource(name))
    .pipe(vinylBuffer())
  if(config.compress) { p = p.pipe(uglify({preserveComments: 'some'})) }
  return p.pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(config.nonRevOutputDir))
}

var npmDependencies = getNPMPackageIds()

var appPack = browserify({
  entries: config.js.entries,
  paths: ['./app/assets/javascripts/', './assets/javascripts/components'],
  extensions: ['.jsx'],
  debug: true,
}).external(npmDependencies)

var testPack = browserify({
  entries: glob.sync(config.js.testDir + '/**/*Spec.js?(x)'),
  paths: ['./app/assets/javascripts/', './assets/javascripts/components'],
  extensions: ['.jsx'],
  debug: true,
}).external(npmDependencies).transform(babelify)

var vendorPack = browserify({
  debug: false,
  require: npmDependencies,
})

gulp.task('js', ['js-vendor', 'js-app'])
gulp.task('js-app', function() { return bundle(appPack, config.js.outputFile) })
gulp.task('js-test', function() { return bundle(testPack, config.js.testOutputFile) })
gulp.task('js-vendor', function() { return bundle(vendorPack, 'vendor.js') })
