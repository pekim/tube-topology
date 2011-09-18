fetch = require '../lib/fetch-prediction-summary'

exports.fetch = (test) ->
  fetch 'http://cloud.tfl.gov.uk/TrackerNet/PredictionDetailed/V/OXC', (error, prediction) ->
    test.ok(prediction)
    test.strictEqual(prediction.Line, 'V')
    test.strictEqual(prediction.S['@'].Code, 'OXC')

    test.done()
