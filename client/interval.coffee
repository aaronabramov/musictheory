Note = require './note.coffee'

# Interval class, which contains two notes of arbitrary pitch
module.exports = class Interval
  DEFAULT_RANDOM_INTERVAL_RANGE: [0, 12]

  DEFAULT_RANDOM_NOTE_RANGE: ["C1", "C4"]

  # @param [Number, String] bottom note of interval.
  # @param [Number, String] top note of interval.
  constructor: (@bot, @top) ->
    @bot instanceof Note or @bot = new Note(@bot)
    @top instanceof Note or @top = new Note(@top)
    @value = @bot.interval(@top)

  # --------------------------- Constructor Methods --------------------------#

  # Generate random interval in given range.
  # TODO: Interval factory.
  # TODO: Interval range.
  #
  # @param [Number] minimum interval.
  # @param [Number] maximum interval.
  # @param [Number, String] lowest possible note.
  # @param [Number, String] highest possible note.
  @random: (min, max, bot, top) ->
    min ?= this::DEFAULT_RANDOM_INTERVAL_RANGE[0]
    max ?= this::DEFAULT_RANDOM_INTERVAL_RANGE[1]
    bot ?= this::DEFAULT_RANDOM_NOTE_RANGE[0]
    top ?= this::DEFAULT_RANDOM_NOTE_RANGE[1]
    interval = _.random(min, max)
    [bot, top] = [Note.literalToMidi(bot), Note.literalToMidi(top)]
    botNote = _.random(bot, top - interval)
    topNote = _.random(bot + interval, top)
    # Swap if bottom note is higher then top.
    # TODO: configurable (upwards|downwards) intervals.
    [botNote, topNote] = [topNote, botNote] if botNote > topNote
    new this(botNote, topNote)
