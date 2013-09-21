# Module contains logic for building client side javascript bundle
#       including compiling coffeescript file and creating browesrify bundle.

coffee = require 'coffee-script'
through = require 'through'
walk = require 'walk'
path = require 'path'
browserify = require 'browserify'

BASE_DIR = "#{process.cwd()}/client"

# Transform function to compile coffescript files.
transform = (file) ->
    data = ''
    write =  (buf) -> data += buf
    end = ->
      @queue coffee.compile(data)
      @queue null
    through(write, end)

# Get module expose path form its full path.
# @example
#       exposePath '/user/abc/app/client/views/home_view.coffee' # => '/views/home_view'
exposePath = (filePath) ->
  path.relative(BASE_DIR, filePath).replace(/\.coffee$/, '')

# Recursively get paths for all files in bundle directory.
# @param [Function] callback function. array with path string will
#       be passed as an argument.
getFilePaths = (callback) ->
  filePaths = []
  walker = walk.walk BASE_DIR
  walker.on 'file', (root, file, next) ->
    filePaths.push(path.normalize "#{root}/#{file.name}")
    next()
  walker.on 'end', -> callback(filePaths)

# @param [Array] array of file paths to require into bundle.
# Build bundle and pass it to the callback as an argument.
module.exports.bundle = (callback) ->
  b = browserify()
  b.transform transform
  getFilePaths (files) ->
    files.forEach (file) -> b.require file, expose: exposePath(file)
    callback(b.bundle())
