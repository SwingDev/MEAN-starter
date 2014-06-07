var gulp = require('gulp');
    sass = require('gulp-ruby-sass'),
    gutil = require('gulp-util')
    coffee = require('gulp-coffee');

gulp.task('styles', function() {
  return gulp.src(['css/**/*.scss', '!css/**/_*.scss'])
    .pipe(sass({loadPath: ['css/']}).on('error', gutil.log))
    // .pipe(sass({includePaths: ['css/'], errLogToConsole: true})) // this work with gulp-sass, which is quicker but less reliable
    .pipe(gulp.dest('css/'));
});

gulp.task('coffee', function() {
  gulp.src('./js/**/*.coffee')
      .pipe(coffee().on('error', gutil.log))
      .pipe(gulp.dest('./js'));
});

gulp.task('watch', function() {
    gulp.watch('./js/**/*.coffee', function(event) {
      console.log('File '+event.path+' was '+event.type+', running tasks...');
      gulp.run('coffee');
    });

    gulp.watch(['css/**/*.scss', '!css/**/_*.scss'], function(event) {
      console.log('File '+event.path+' was '+event.type+', running tasks...');
      gulp.run('styles');
    });
});