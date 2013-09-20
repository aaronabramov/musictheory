stylus = require 'stylus'
nib = require 'nib'

# Compile function
compile = (str, path) ->
  stylus(str)
    .set('filename', path)
    .set('compress', true)
    .use(nib())


module.exports.cssMiddleware = stylus.middleware
  src: __dirname + '../public'
  compile: compile
