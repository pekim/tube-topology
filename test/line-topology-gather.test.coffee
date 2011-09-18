LineTopologyGatherer = require('../lib/line-topology-gather')

fs = require 'fs'
Seq = require 'seq'
xml2js = require 'xml2js'

exports.stations = (test) ->
  gatherer = new LineTopologyGatherer

  gatherFile = (filename, done) ->
    Seq()
    .seq () ->
      fs.readFile filename, 'ascii', this
    .seq (xml) ->
      parser = new xml2js.Parser
      parser.addListener 'end', (object) =>
        this undefined, object
      parser.parseString xml
    .seq (object) ->
      gatherer.addPrediction object

      done undefined

  Seq()
  .seq () ->
    gatherFile 'test/data/gather-1.xml', this
  .seq () ->
    gatherFile 'test/data/gather-2.xml', this
  .seq () ->
    gatherFile 'test/data/gather-3.xml', this
  .seq () ->
    stations = gatherer.getStations()
    test.strictEqual Object.keys(stations).length, 2
    test.strictEqual stations.AAA.name, 'Aaa'
    test.strictEqual stations.BBB.name, 'Bbb'

    platforms = stations.AAA.platforms
    test.strictEqual Object.keys(platforms).length, 2
    test.strictEqual platforms['1'].trackCode, 'tc-1'
    test.strictEqual platforms['2'].trackCode, 'tc-2'

    trains = gatherer.getTrains()
    test.strictEqual Object.keys(trains).length, 3

    test.done()
  .catch (error) ->
    console.log 'ERROR', error
