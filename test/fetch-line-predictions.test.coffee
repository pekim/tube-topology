fs = require 'fs'
fetch = require '../lib/fetch-line-predictions'

exports.fetch = (test) ->
  line = JSON.parse(fs.readFileSync 'data/bakerloo.stations.json', 'ascii')
  stationCodes = (code for code, dummy of line.stations)

  predictions = 0;

  fetch line.code, stationCodes, 10 * 1000, (error, stationPrediction) ->
    #console.log stationPrediction
    test.ok(stationPrediction)
    test.strictEqual(stationPrediction.Line, line.code)

    predictions++
    if (predictions == 2)
      test.done()

      true # stop
