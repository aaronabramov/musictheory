# WIP
module.exports = class Audio extends Backbone.View
  # @param [Note]
  initialize: ({@note}) ->
    $('body').append(@render().el)

  tagName: 'audio'

  url: -> encodeURIComponent "/audio/#{@note.toString()}.mp3"

  render: ->
    @$el.html "<source src='#{@url()}'></source>"
    this

  play: =>
    @el.play()

  duration: =>
    # Delay compensation
    @el.duration * 1000 - 100
