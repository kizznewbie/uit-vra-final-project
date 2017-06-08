var gulp = require('gulp'),
    del = require('del'),
    jade = require('gulp-jade'),
    sass = require('gulp-sass'),
    imageMin = require('gulp-imagemin'),
    nodemon = require('gulp-nodemon'),
    concat = require('gulp-concat');

/*----------CONFIG----------*/
var path = {
  sass: ['./source/css/**/*.scss'],
  cssLib: ['./source/css/**/*.css'],
  jade: ['./source/jade/**/*.jade'],
  js: ['./source/js/**/*.js', '!./source/js/lib/*.js'],
  jsLib: ['./source/js/lib/*.js'],
  imgs: ['./source/imgs/*.*']
};

var dest = {
  jade: './public/html',
  jsLib: './public/js/lib',
  cssLib: './public/css/lib',
  js: './public/js',
  sass: './public/css',
  imgs: './public/imgs'
}

gulp.task('del', function() {
  console.log('cleaning public directory...');
  return del(['./public/*']);
});

gulp.task('jade', function() {
  gulp
    .src(path.jade)
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest(dest.jade));
});

gulp.task('sass', function() {
  gulp
    .src(path.sass)
    .pipe(sass().on('error', sass.logError))
    .pipe(concat('all.css'))
    .pipe(gulp.dest(dest.sass));
});

gulp.task('concatJSLib', function() {
    gulp
      .src(path.jsLib)
      .pipe(concat('lib.js'))
      .pipe(gulp.dest(dest.jsLib))
});

gulp.task('concatCSSLib', function() {
    gulp
      .src(path.cssLib)
      .pipe(concat('lib.css'))
      .pipe(gulp.dest(dest.cssLib))
});

gulp.task('concatJS', function() {
    gulp
      .src(path.js)
      .pipe(concat('all.js'))
      .pipe(gulp.dest(dest.js))
});

gulp.task('imgMin', function() {
    gulp
      .src(path.imgs)
      .pipe(imageMin())
      .pipe(gulp.dest(dest.imgs))
});

gulp.task('startServer', function() {
  nodemon({
    script: './server.js'
  });
});


gulp.task('watch', function() {
  gulp.watch(path.jsLib, ['concatJSLib']);
  gulp.watch(path.js, ['concatJS']);
  gulp.watch(path.jade, ['jade']);
  gulp.watch(path.sass, ['sass']);
});

gulp.task('default', ['del'], function() {
  console.log('Staring dev task...');
  gulp.start('dev');
});

gulp.task('dev', ['jade', 'sass', 'concatJSLib', 'concatJS', 'concatCSSLib', 'imgMin','startServer', 'watch']);
