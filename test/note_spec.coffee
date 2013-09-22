Note = require 'note'

describe "note", ->
  describe "#constructor", ->
    it "takes string literal", ->
      (new Note('c4')).should.be.an.instanceOf Note

    it "takes number literal", ->
      (new Note(44)).should.be.an.instanceOf Note

    it "parses sharp literals", ->
      (new Note('c#3')).intonation.should.be.equal "#"

    it "parses flat literals", ->
      (new Note('ab4')).intonation.should.be.equal "b"

    it "parses literals without specified octave", ->
      (new Note('f')).should.be.an.instanceOf Note

    it "throws an error if literal is invalid", ->
      expect(-> new Note('4c')).to.throw(/wrong.+format/)

    it "extracts note, octave, intonaton from literal", ->
      subject = new Note 'cb4'
      subject.name.should.be.equal 'C'
      subject.octave.should.be.equal 4
      subject.intonation.should.be.equal 'b'

  describe "#interval", ->
    it "returns number for halfsteps between two notes", ->
      (new Note 'c2').interval(new Note('c3')).should.be.equal 12

    it "takes note literals", ->
      (new Note 'c2').interval('c4').should.be.equal 24

    it "returns negative intervals", ->
      (new Note 'c4').interval('c2').should.be.equal -24

  describe "#MIDICode", ->
    it "returns midi index for note", ->
      (new Note 'c4').MIDICode().should.be.equal 60

    it "returns midi index for sharp notes", ->
      (new Note 'c#4').MIDICode().should.be.equal 61

    it "returns midi index for flat notes", ->
      (new Note 'cb4').MIDICode().should.be.equal 59

  describe "toFreq", ->
    it "returns note frequency", ->
      (new Note 'f6').toFreq().toFixed(2).should.be.equal '1396.91'

  describe "#toString", ->
    it "returns note literal", ->
      (new Note 'b#4').toString().should.be.equal 'B#4'

  context "Constructor methods", ->
    describe "#fromMIDI", ->
      it "returns note instance based on passed midi index", ->
        Note.fromMIDI(44).MIDICode().should.be.equal 44
