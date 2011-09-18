class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @trackCodes = {}

  addPrediction: (prediction) ->
    if !@stations[prediction.S['@'].Code]
      platforms = {}
      for platform in prediction.S.P
        platforms[platform['@'].Num] = 
          name: platform['@'].N
          number: platform['@'].Num
          trackCode: platform['@'].TrackCode

      @stations[prediction.S['@'].Code] =
        code: prediction.S['@'].Code
        name: prediction.S['@'].N
        platforms: platforms

  getStations: () ->
    @stations

module.exports = LineTopologyGatherer
