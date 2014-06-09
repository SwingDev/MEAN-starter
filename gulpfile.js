var gulp       = require('gulp');
    gutil      = require('gulp-util')
    coffee     = require('gulp-coffee');
    watch      = require('gulp-watch');
    merge      = require('merge-stream');
    coffeelint = require('gulp-coffeelint')


gulp.task('watch', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(watch({emit: 'all'}))
          .pipe(coffeelint())
          .pipe(coffeelint.reporter())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(watch({emit: 'all'}))
          .pipe(gulp.dest('./build/server/'))
        );
});


gulp.task('compile', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(coffeelint())
          .pipe(coffeelint.reporter())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(gulp.dest('./build/server/'))
        );
});