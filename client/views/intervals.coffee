Note = require '../note.coffee'
Audio = require '../audio.coffee'

module.exports = class Intervals extends Backbone.View
  initialize: ->
    @randomInterval()

  bindEvents: ->
    $('a').on 'click', @check

  unbindEvents: ->
    $('a').off()

  randomInterval: =>
    @bindEvents()
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

  check: (e) =>
    @unbindEvents()
    $el = $(e.currentTarget)
    if $el.data('interval') is interval = @one.note.interval(@two.note)
      $el.addClass 'correct'
    else
      $el.addClass 'incorrect'
      @$("a[data-interval=#{interval}]").addClass('correct')
    _.delay @randomInterval, 1500
