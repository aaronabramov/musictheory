# Representation of musical note.
module.exports = class Note
  NOTE_REGEX: ///
    ^
    ([a-gA-G]{1})       # Note name
    ([#b]?)             # Intonation
    (?:([-]?\d+)|(\d*)) # Octave (may be negative)
    $
  ///

  DEFAULT_OCTAVE: 2

  ZERO_OCTAVE: -1

  ZERO_NOTE: "C"

  CENTRAL_NOTE: "A4"

  CENTRAL_PITCH: 440 # Hz

  INDEXED_NOTE_NAMES: {C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11}

  DEFAULT_RANDOM_RANGE: [36, 60] # C2, C4

  # @param [String, Number] note literal "C", "c#9", "c3", "Gb4", "A-1"
  constructor: (literal) ->
    [name, @intonation, octave] = _.rest(literal.match(@NOTE_REGEX))
    name and @name = name.toUpperCase()
    @name or throw new Error "wrong literal format: #{literal}"
    octave and @octave ||= parseInt(octave)
    # NOTE: zero octave
    @octave ?= @DEFAULT_OCTAVE

  # @param [Note, String] other note to compare.
  # @return [Number] Numeric interval representation.
  interval: (other) ->
    other = new @constructor(other) unless other instanceof @constructor
    other.MIDICode() - @MIDICode()

  # @return [Number] Midi code of the note.
  MIDICode: ->
    number = (@octave - @ZERO_OCTAVE) * 12 + @INDEXED_NOTE_NAMES[@name]
    number++ if @intonation is "#"
    number-- if @intonation is "b"
    number

  # @return [Number] Note pitch in Hz. relative to central note.
  toFreq: ->
    n = -@interval(@CENTRAL_NOTE)
    Math.pow(2, n / 12) * @CENTRAL_PITCH

  # @return [String] Note literal.
  toString: ->
    "#{@name}#{@intonation}#{@octave}"

  #--------------------------- Constructor Methods ----------------------------#

  # @param [Number, String] Lowest possible note.
  # @param [Number, String] Highest possible note.
  @random: (min, max) ->
    min ?= this::DEFAULT_RANDOM_RANGE[0]
    max ?= this::DEFAULT_RANDOM_RANGE[1]
    min = (new @constructor(min)).MIDICode() unless _.isNumber(min)
    max = (new @constructor(max)).MIDICode() unless _.isNumber(max)
    @fromMIDI _.random(min, max)

  # @param [Number] MIDI code of the note.
  # @return [Note] parsed instance of Note.
  @fromMIDI: (number) ->
    octave = Math.floor(number / 12) - 1
    pairs = _.pairs(this::INDEXED_NOTE_NAMES)
    [name] = (_.find pairs, (p) -> p[1] is number % 12) or []
    if name
      intonation = ""
    else
      intonation = "#"
      [name] = _.find pairs, (p) -> p[1] is ((number % 12) - 1)
    new this "#{name}#{intonation}#{octave}"
