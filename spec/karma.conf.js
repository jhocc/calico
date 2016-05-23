module.exports = function(config) {
  config.set({
    basePath: '../',
    frameworks: ['jasmine'],
    files: [
      'public/assets/vendor.js',
      'public/assets/app-test.js'
    ],
    exclude: [],
    reporters: ['progress'],
    preprocessors: {
      '**/*.js': ['sourcemap'],
    },
    port: 9876,
    runnerPort: 9100,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome', 'Firefox'],
    captureTimeout: 60000,
    browserNoActivityTimeout: 30000,
    singleRun: true,
  });
};
