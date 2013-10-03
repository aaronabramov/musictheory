# WIP
Note = require 'note'
Audio = require 'audio'
{random} = require 'factories/interval'

Intervals = module.exports

class Intervals.View extends Backbone.View
  template: -> require('templates/intervals.hamlc').apply(this, arguments)

  initialize: ->
    @randomInterval()

  render: ->
    @$el.html @template()
    this

  bindEvents: ->
    $('a').on 'click', @check

  unbindEvents: ->
    $('a').off()

  randomInterval: =>
    @bindEvents()
    @$('a').removeClass('correct incorrect')
    # @one?.remove()
    # @two?.remove()
    # @one = new Audio(note: Note.random())
    # @two = new Audio(note: Note.random())
    # if @one.note.interval(@two.note) < 0
    #   # Use upwards
    #   [@one, @two] = [@two, @one]
    # @play()

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
