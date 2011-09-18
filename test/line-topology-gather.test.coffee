LineTopologyGatherer = require('../lib/line-topology-gather')

exports.simple = (test) ->
  new LineTopologyGatherer

  test.done()
