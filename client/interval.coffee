Note = require 'note'

# Interval class, which contains two notes of arbitrary pitch
module.exports = class Interval
  value: null

  # @param [Number, String] bottom note of interval.
  # @param [Number, String] top note of interval.
  constructor: (@bot, @top) ->
    @bot instanceof Note or @bot = new Note(@bot)
    @top instanceof Note or @top = new Note(@top)
    @value = @bot.interval(@top)
