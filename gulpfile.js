// Include Gulp plugins.
var gulp        = require('gulp'),
    watch       = require('gulp-watch'),
    gutil       = require('gulp-util'),
    coffeelint  = require('gulp-coffeelint'),
    sourcemaps  = require('gulp-sourcemaps'),
    coffee      = require('gulp-coffee'),
    concat      = require('gulp-concat'),
    uglify      = require('gulp-uglify'),
    scsslint    = require('gulp-scsslint'),
    compass     = require('gulp-compass'),
    minifyCSS   = require('gulp-minify-css'),
    del         = require('del'),
    mbf         = require('main-bower-files'),
    runSequence = require('run-sequence'),
    livereload  = require('gulp-livereload'),
    ngAnnotate  = require('gulp-ng-annotate');

// Application configuration file.
var appconfig   = require('./appconfig');

// Compile backend scripts.
gulp.task('compile_backend_scripts', function() {
  gulp.src('development/backend/**/*.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(sourcemaps.init())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./build/backend/'));
});

// Compile frontend scripts.
gulp.task('compile_frontend_scripts', function() {
  gulp.src('development/frontend/**/*.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(sourcemaps.init())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
      .pipe(concat(appconfig.id + '.js'))
      .pipe(ngAnnotate())
      .pipe(uglify())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./build/frontend/scripts/'))
    .pipe(livereload());
});

// Compile Bower components.
gulp.task('compile_bower_components', function() {
  gulp.src(mbf(), { base: 'bower_components'})
    .pipe(concat('vendor.js'))
    .pipe(ngAnnotate())
    .pipe(uglify()) // This can take some time.
    .pipe(gulp.dest('./build/frontend/scripts'))
    .pipe(livereload());
});

// Compile SASS styles.
gulp.task('compile_app_styles', function() {
  gulp.src('development/frontend/styles/'+ appconfig.id +'.scss')
    .pipe(scsslint())
    .pipe(scsslint.reporter())
    .on('error', gutil.log)
    .pipe(compass({
      project: __dirname,
      css: 'build/frontend/styles',
      sass: 'development/frontend/styles'
    }))
    .on('error', gutil.log)
    .pipe(minifyCSS())
    .pipe(gulp.dest('./build/frontend/styles'))
    .pipe(livereload());
});

// Compile Bootstrap styles.
gulp.task('compile_bootstrap_styles', function() {
  gulp.src('development/frontend/vendor/bootstrap-sass/bootstrap.scss')
    .pipe(compass({
      project: __dirname,
      css: 'build/frontend/styles',
      sass: 'development/frontend/vendor/bootstrap-sass',
      sourcemap: true
    }))
    .on('error', gutil.log)
    .pipe(minifyCSS())
    .pipe(gulp.dest('./build/frontend/styles'))
    .pipe(livereload());
});

// Update assets
gulp.task('update_assets', function() {
  gulp.src('development/frontend/assets/**/*')
    .pipe(gulp.dest('./build/frontend'))
    .pipe(livereload());
});

// Compile task.
gulp.task('compile', function() {
  runSequence([
    'compile_backend_scripts',
    'compile_frontend_scripts',
    'compile_bower_components',
    'compile_bootstrap_styles',
    'compile_app_styles',
    'update_assets'
  ]);
});

// Watch task.
gulp.task('watch', function() {

  livereload.listen();

  // Compile added or changed backend script.
  watch('development/backend/**/*.coffee', { events: ['add', 'change'] }, function(vinyl) {
    gutil.log('Compiling backend script...');

    dest = vinyl.path.replace(vinyl.base, './build/backend');
    dest = dest.substr(dest.indexOf('/./') + 1);
    dest = dest.substr(0, dest.lastIndexOf('/'));

    gulp.src(vinyl.path)
      .pipe(coffeelint())
      .pipe(coffeelint.reporter())
      .pipe(sourcemaps.init())
        .pipe(coffee({ bare: true }))
        .on('error', gutil.log)
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest(dest));
  });

  // Unlink selected backend script.
  watch('development/backend/**/*.coffee', { events: ['unlink'] }, function(vinyl) {
    gutil.log('Deleting backend script...');

    path    = vinyl.path.replace(vinyl.base, './build/backend');
    pathJS  = path.replace('.coffee', '.js');
    pathMap = pathJS + '.map';

    del([pathJS, pathMap], function(error, deletedFiles) {
      if(error)
        gutil.log(error);

      gutil.log('Deleted file: ', deletedFiles.join(', '));
    });
  })

  // Compile all frontend scripts.
  watch('development/frontend/**/*.coffee', function() {
    gutil.log('Compiling frontend scripts...');

    gulp.start('compile_frontend_scripts');
  });

  // Compile all bower components.
  watch('bower_components/**/*', function() {
    gutil.log('Compiling Bower components...');

    gulp.start('compile_bower_components');
  });

  // Compile all frontend styles.
  watch('development/frontend/styles/**/*.scss', function() {
    gutil.log('Compiling frontend styles...');

    gulp.start('compile_app_styles');
  });

  // Update set of frontend assets.
  watch('development/frontend/assets/**/*', { events: ['add', 'change'] }, function() {
    gutil.log('Updating frontend assets...');

    gulp.start('update_assets');
  })

  // Unlink selected asset.
  watch('development/frontend/assets/**/*', { events: ['unlink'] }, function(vinyl) {
    gutil.log('Deleting frontent asset file...');

    path = vinyl.path.replace(vinyl.base, './build/frontend');

    del(path, function(error, deletedFiles) {
      if(error)
        gutil.log(error);

      gutil.log('Deleted file: ', deletedFiles.join(', '));
    });
  });
});
