fetch = require '../lib/fetch-prediction-summary'

exports.fetch = (test) ->
  fetch 'http://cloud.tfl.gov.uk/TrackerNet/PredictionDetailed/V/OXC', (error, prediction) ->
    console.log prediction
    test.done()
