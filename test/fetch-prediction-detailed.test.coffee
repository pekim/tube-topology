fetch = require '../lib/fetch-prediction-detailed'

exports.fetch = (test) ->
  line = 'V'
  station = 'OXC'

  fetch line, station, (error, prediction) ->
    test.ok(prediction)
    test.strictEqual(prediction.Line, line)
    test.strictEqual(prediction.S['@'].Code, station)

    test.done()
