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

  # @param [String] note literal "C", "c#9", "c3", "Gb4"
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
