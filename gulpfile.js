var gulp       = require('gulp');
    gutil      = require('gulp-util')
    coffee     = require('gulp-coffee');
    watch      = require('gulp-watch');
    merge      = require('merge-stream');
    coffeelint = require('gulp-coffeelint');
    plumber    = require('gulp-plumber');

var onError = function (err) {  
  gutil.beep();
  gutil.log(err);
};

gulp.task('watch', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(plumber({errorHandler: onError}))
          .pipe(watch({glob: './development/server/**/*.coffee'}))
          .pipe(coffeelint())
          .pipe(coffeelint.reporter())
          .pipe(coffee({bare: true}))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(plumber({errorHandler: onError}))
          .pipe(watch({glob: ['./development/server/**/*', '!./development/server/**/*.coffee']}))
          .pipe(gulp.dest('./build/server/'))
        );
});


gulp.task('compile', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(plumber({errorHandler: onError}))
          .pipe(coffeelint())
          .pipe(coffeelint.reporter())
          .pipe(coffee({bare: true}))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(plumber({errorHandler: onError}))
          .pipe(gulp.dest('./build/server/'))
        );
});