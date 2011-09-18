fetch = require '../lib/fetch-prediction-summary'

exports.fetch = (test) ->
  line = 'V'
  station = 'OXC'

  fetch line, station, (error, prediction) ->
    test.ok(prediction)
    test.strictEqual(prediction.Line, line)
    test.strictEqual(prediction.S['@'].Code, station)

    test.done()
