var gulp       = require('gulp');
    gutil      = require('gulp-util')
    coffee     = require('gulp-coffee');
    watch      = require('gulp-watch');
    merge      = require('merge-stream');
    coffeelint = require('gulp-coffeelint')


gulp.task('watch', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(watch({glob: './development/server/**/*.coffee'}))
          .pipe(coffeelint()).on('error', function(){})
          .pipe(coffeelint.reporter()).on('error', function(){})
          .pipe(coffee({bare: true})).on('error', gutil.log)
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(watch({glob: ['./development/server/**/*', '!./development/server/**/*.coffee']}))
          .pipe(gulp.dest('./build/server/'))
        );
});


gulp.task('compile', function() {
  return merge(
          gulp.src('./development/server/**/*.coffee')
          .pipe(coffeelint()).on('error', function(){})
          .pipe(coffeelint.reporter()).on('error', function(){})
          .pipe(coffee({bare: true})).on('error', gutil.log)
          .pipe(gulp.dest('./build/server/')),
          gulp.src(['./development/server/**/*', '!./development/server/**/*.coffee'])
          .pipe(gulp.dest('./build/server/'))
        );
});