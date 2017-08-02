var gulp        = require('gulp');
var browserSync = require('browser-sync').create();

// Static Server + watching css/html files
gulp.task('serve', ['css'], function() {

    browserSync.init({
        server: "./",
        open: false
    });

    gulp.watch("*.css", ['css']);
    gulp.watch("*.html").on('change', browserSync.reload);
});

// auto-inject css into browsers
gulp.task('css', function() {
    return gulp.src("*.css")
        .pipe(browserSync.stream());
});

gulp.task('default', ['serve']);
