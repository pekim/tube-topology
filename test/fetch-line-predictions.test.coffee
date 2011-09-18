fetch = require '../lib/fetch-line-predictions'

exports.fetch = (test) ->
  line = 'V'
  predictions = 0;

  fetch line, (error, stationPrediction) ->
    test.ok(stationPrediction)
    test.strictEqual(stationPrediction.Line, line)
    predictions++

    if (predictions == 2)
      test.done()
