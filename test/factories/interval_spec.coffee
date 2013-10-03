Interval = require 'interval'
{random} = require 'factories/interval'

describe 'factories/interval', ->
  describe '#random', ->
    it "returns interval within given range", ->
      intervals = (random(0, 12, 'C1', 'C4').value for i in [1..100])
      _.max(intervals).should.be.below 13
      _.min(intervals).should.be.at.least 0
