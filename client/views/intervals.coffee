Note = require '../note.coffee'
Audio = require '../audio.coffee'

module.exports = class Intervals extends Backbone.View

  initialize: ->

  randomInterval: ->
    @one?.remove()
    @two?.remove()
    @one = new Audio(note: Note.random('c2', 'c3'))
    @two = new Audio(note: Note.random('c2', 'c3'))
    @play()

  play: =>
    @one.play()
    _.delay @two.play, 1000
