Note = require 'note'

module.exports = class Audio
  AUDIO_CONTAINER_CLASS: _.uniqueId 'audio-elements-container-'

  # @return [$] container element
  @container: ->
    container = $(".#{Audio::AUDIO_CONTAINER_CLASS}")
    return container if container.length
    $("<div class=#{Audio::AUDIO_CONTAINER_CLASS}>").appendTo($ 'body')

  # @param [Note, String, Number]
  constructor: ({@note}) ->
    @note instanceof Note or @note = new Note(@note)
    Audio.container().append @render()

  render: -> @el = $("<audio><source src=#{@url()}></source></audio>")[0]

  url: -> encodeURIComponent "/audio/#{@note.toString()}.mp3"

  play: => @el.play()

  duration: => @el.duration * 1000 - 100 # Delay compensation
