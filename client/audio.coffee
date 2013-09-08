module.exports = class Audio extends Backbone.View
  initialize: ({@name}) ->

  tagName: 'audio'

  url: -> "/audio/#{@name}.mp3"

  render: ->
    @$el.html "<source src='#{@url()}'></source>"
    this

  play: =>
    @el.play()

  duration: =>
    # Delay compensation
    @el.duration * 1000 - 100
