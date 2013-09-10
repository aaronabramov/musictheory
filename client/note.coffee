module.exports = class Note
  DEFAULT_OCTAVE: 2

  NOTE_REGEX: ///
    ^
    ([a-gA-G]{1})       # Note name
    ([#b]?)             # Intonation
    (?:([-]?\d+)|(\d*)) # Octave (may be negative)
    $
  ///

  ZERO_OCTAVE: -1

  ZERO_NOTE: "C"

  INDEXED_NOTE_NAMES: {C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11}

  # @param [Number, String] Lowest possible note.
  # @param [Number, String] Highest possible note.
  @random: (min, max) ->
    min = (new @constructor(min)).MIDICode() unless _.isNumber(min)
    max = (new @constructor(max)).MIDICode() unless _.isNumber(max)


  # @param [String, Number] note literal "C", "c#9", "c3", "Gb4"
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
    new this("#{name}#{intonation}#{octave}")
