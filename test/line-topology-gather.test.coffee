LineTopologyGatherer = require('../lib/line-topology-gather')

exports.stations = (test) ->
  gatherer = new LineTopologyGatherer

  gatherer.addPrediction
    S:
      '@':
        Code: 'AAA'
        N: 'Aaa'
        CurTime: '00:01:01'
      P: [
        {
          '@':
            N: 'N1'
            Num: '1'
            TrackCode: 'TCA1'
        }
        {
          '@':
            N: 'S2'
            Num: '2'
            TrackCode: 'TCA2'
        }
      ]

  gatherer.addPrediction
    S:
      '@':
        Code: 'BBB'
        N: 'Bbb'
        CurTime: '00:01:02'
      P: []

  gatherer.addPrediction
    S:
      '@':
        Code: 'AAA'
        N: 'Aaa'
        CurTime: '00:01:03'
      P: []

  stations = gatherer.getStations()
  test.strictEqual Object.keys(stations).length, 2
  test.strictEqual stations.AAA.name, 'Aaa'
  test.strictEqual stations.BBB.name, 'Bbb'

  platforms = stations.AAA.platforms
  test.strictEqual Object.keys(platforms).length, 2
  test.strictEqual platforms['1'].trackCode, 'TCA1'
  test.strictEqual platforms['2'].trackCode, 'TCA2'

  test.done()
