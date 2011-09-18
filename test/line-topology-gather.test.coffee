LineTopologyGatherer = require('../lib/line-topology-gather')

exports.stations = (test) ->
  gatherer = new LineTopologyGatherer

  gatherer.addPrediction
    S:
      '@':
        Code: 'AAA'
        N: 'Aaa'
        CurTime: '00:01:01'

  gatherer.addPrediction
    S:
      '@':
        Code: 'BBB'
        N: 'Bbb'
        CurTime: '00:01:02'

  gatherer.addPrediction
    S:
      '@':
        Code: 'AAA'
        N: 'Aaa'
        CurTime: '00:01:03'

  stations = gatherer.getStations()
  test.strictEqual Object.keys(stations).length, 2
  test.strictEqual stations.AAA.name, 'Aaa'
  test.strictEqual stations.BBB.name, 'Bbb'

  test.done()
