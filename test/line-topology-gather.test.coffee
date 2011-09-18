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
          T: [
            {
              '@':
                LCID: 'l-1'
                SetNo: 's-1'
                TripNo: 't-1'
                TrackCode: 'tc1'
            }
            {
              '@':
                LCID: 'l-2'
                SetNo: 's-2'
                TripNo: 't-1'
                TrackCode: 'tc2'
            }
          ]
        }
        {
          '@':
            N: 'S2'
            Num: '2'
            TrackCode: 'TCA2'
          T: [
            {
              '@':
                LCID: 'l-2'
                SetNo: 's-2'
                TripNo: 't-1'
                TrackCode: 'tc3'
            }
            {
              '@':
                LCID: 'l-3'
                SetNo: 's-3'
                TripNo: 't-1'
                TrackCode: 'tc4'
            }
          ]
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

  trains = gatherer.getTrains()
  test.strictEqual Object.keys(trains).length, 3

  test.done()
