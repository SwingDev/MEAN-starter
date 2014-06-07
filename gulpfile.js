var gulp = require('gulp');
    gutil = require('gulp-util')
    coffee = require('gulp-coffee');
    watch = require('gulp-watch');
    merge = require('merge-stream');


gulp.task('compile', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(watch())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(watch())
          .pipe(gulp.dest('./build/server/views/'))
        );
});


gulp.task('compile', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(gulp.dest('./build/server/'))
        );
});