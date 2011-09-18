class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @trackCodes = {}

  addPrediction: (prediction) ->
    if !@stations[prediction.S['@'].Code]
      @stations[prediction.S['@'].Code] =
        code: prediction.S['@'].Code
        name: prediction.S['@'].N

  getStations: () ->
    @stations

module.exports = LineTopologyGatherer
