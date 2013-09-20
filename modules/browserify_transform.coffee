coffee = require 'coffee-script'
through = require 'through'

module.exports = (file) ->
    data = ''
    write =  (buf) -> data += buf
    end = ->
      @queue(coffee.compile(data))
      @queue(null)
    through(write, end)
