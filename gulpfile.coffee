coffee       = require 'gulp-coffee'
concat       = require 'gulp-concat'
gulp         = require 'gulp'
gutil        = require 'gulp-util'
plumber      = require 'gulp-plumber'
watch        = require 'gulp-watch'

# Paths to source files

coffeePath        = 'app/coffee/**/*.coffee'

js = (cb)->
  # App
  gulp.src( coffeePath )
    .pipe plumber() 
    .pipe coffee( bare: true ).on( 'error', gutil.log ) .on( 'error', gutil.beep )
    .pipe concat('app.js') 
    .pipe gulp.dest('../')
    .on('end', cb) 


# Livereload Server
watchAndCompileFiles = (cb)->
  count = 0
  onComplete = ()=> if ++count == 6 then cb()

  watch { glob:coffeePath},  -> js(onComplete)

  # ----------- MAIN ----------- #

gulp.task 'compile', (cb) -> watchAndCompileFiles(cb)
gulp.task 'default', ['compile']

