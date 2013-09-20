window.require = require
Audio = require './audio.coffee'
window.Interval = require './interval.coffee'
Intervals = require './views/intervals.coffee'
Note = require './note.coffee'

window.files = []
$ ->
  window.intervals = new Intervals
    el: $('.b-intervals')
