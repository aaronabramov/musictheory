Note = require 'note'
Interval = require 'interval'

module.exports =
  DEFAULT_RANDOM_INTERVAL_RANGE: [0, 12]

  DEFAULT_RANDOM_NOTE_RANGE: ["C1", "C4"]

  # Generate random interval in given range.
  #
  # @param [Number] minimum interval.
  # @param [Number] maximum interval.
  # @param [Number, String] lowest possible note.
  # @param [Number, String] highest possible note.
  # @return [Inverval]
  random: (min, max, bot, top) ->
    min ?= @DEFAULT_RANDOM_INTERVAL_RANGE[0]
    max ?= @DEFAULT_RANDOM_INTERVAL_RANGE[1]
    bot ?= @DEFAULT_RANDOM_NOTE_RANGE[0]
    top ?= @DEFAULT_RANDOM_NOTE_RANGE[1]
    interval = _.random(min, max)
    [bot, top] = [Note.literalToMidi(bot), Note.literalToMidi(top)]
    botNote = _.random(bot, top - interval)
    topNote = botNote + interval
    # TODO: configurable (upwards|downwards) intervals.
    new Interval(botNote, topNote)
