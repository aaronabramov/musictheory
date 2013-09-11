Note = require '../note.coffee'
Audio = require '../audio.coffee'

module.exports = class Intervals extends Backbone.View
  initialize: ->
    @randomInterval()

  events:
    'click a': 'check'

  randomInterval: =>
    @$('a').removeClass('correct incorrect')
    @one?.remove()
    @two?.remove()
    @one = new Audio(note: Note.random('c2', 'c3'))
    @two = new Audio(note: Note.random('c2', 'c3'))
    if @one.note.interval(@two.note) < 0
      # Use upwards
      [@one, @two] = [@two, @one]
    @play()

  play: =>
    @one.play()
    _.delay @two.play, 1000

  check: (e) ->
    $el = $(e.currentTarget)
    console.log $el.data('interval'), @one.note.interval(@two.note).toString()
    if $el.data('interval') is interval = @one.note.interval(@two.note)
      $el.addClass 'correct'
    else
      $el.addClass 'incorrect'
      @$("a[data-interval=#{interval}]").addClass('correct')
    console.log interval
    _.delay @randomInterval, 3000
