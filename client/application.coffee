console.log require
# window.require = require
Intervals = require './views/intervals.coffee'

$ ->
  window.intervals = new Intervals
    el: $('.b-intervals')
