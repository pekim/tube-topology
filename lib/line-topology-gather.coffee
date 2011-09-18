class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @trackCodes = {}
    @trains = {}

  addPrediction: (prediction) ->
    if !@stations[prediction.S['@'].Code]
      @addStation prediction.S

  addStation: (station) ->
    platforms = {}
    for platform in station.P
      platforms[platform['@'].Num] = 
        name: platform['@'].N
        number: platform['@'].Num
        trackCode: platform['@'].TrackCode

    @stations[station['@'].Code] =
      code: station['@'].Code
      name: station['@'].N
      platforms: platforms

  getStations: () ->
    @stations

module.exports = LineTopologyGatherer
