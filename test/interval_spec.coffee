Note = require 'note'
Interval = require 'interval'

describe 'interval', ->
  describe "constructor", ->
    beforeEach -> @subject = new Interval('c4', 'd4')

    it "initializes with @bot and @top notes", ->
      @subject.top.should.be.an.instanceOf Note
      @subject.bot.should.be.an.instanceOf Note

    it "sets it's value", ->
      @subject.value.should.be.equal 2

