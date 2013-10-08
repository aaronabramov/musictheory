# Module contains logic for building client side javascript bundle
#       including compiling coffeescript file and creating browesrify bundle.

coffee = require 'coffee-script'
through = require 'through'
walk = require 'walk'
path = require 'path'
browserify = require 'browserify'
hamlc = require 'haml-coffee'
mkdirp = require 'mkdirp'
fs = require 'fs'

BASE_DIR = "#{process.cwd()}/client"
TMP_DIR = "#{process.cwd()}/tmp/compiled_coffee"
MODIFIED_TIMESTAMPS_PATH = path.join TMP_DIR, "/modified_times_map.json"


# Get module expose path form its full path.
# @example
#       exposePath '/user/abc/app/client/views/home_view.coffee' # => '/views/home_view'
exposePath = (filePath) ->
  path.relative(BASE_DIR, filePath).replace(/\.coffee$/, '')

csTransform = (filePath) ->
  coffee.compile(fs.readFileSync(filePath).toString())

hamlcTransform = (filePath) ->
  "module.exports = " + hamlc.template(fs.readFileSync(filePath).toString(), null, null, placement: 'standalone')

# --------------------------- compile coffeescripts ---------------------------#
getFiles = ->
  files = []
  walker = walk.walk BASE_DIR
  walker.on 'file', (root, file, next) ->
    files.push file
    file.path = path.normalize "#{root}/#{file.name}"
    next()
  walker.on 'end', -> compileCoffee(files)

compileCoffee = (files) ->
  mkdirp.sync TMP_DIR
  timestamps = if fs.existsSync MODIFIED_TIMESTAMPS_PATH
     JSON.parse fs.readFileSync MODIFIED_TIMESTAMPS_PATH
  else
    {}
  compiledPaths = {}
  for file in files
    compiledPath = path.join TMP_DIR, path.relative(BASE_DIR, file.path)
    compiledPath = compiledPath.replace(/\.coffee$/, '.js').replace(/\.hamlc$/, '.hamlc.js')
    compiledPaths[file.path] = compiledPath
    unless timestamps[file.path] is file.mtime.getTime()
      timestamps[file.path] = file.mtime.getTime()
      # TODO: add hamlc
      mkdirp.sync path.dirname compiledPath
      compiled = if /\.hamlc$/.test file.path
        hamlcTransform(file.path)
      else
        csTransform(file.path)
      fs.writeFileSync compiledPath, compiled
  fs.writeFileSync MODIFIED_TIMESTAMPS_PATH, JSON.stringify(timestamps, null, 2)
  buildBundle(compiledPaths)

buildBundle = (compiledPaths) ->
  b = browserify()
  for filePath, compiledPath of compiledPaths
    b.require compiledPath, expose: exposePath(filePath)
  b.bundle().pipe(process.stdout)

getFiles()

# -----------------------------------------------------------------------------#
