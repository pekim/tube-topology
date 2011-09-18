class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @trackCodes = {}
    @trains = {}

  addPrediction: (prediction) ->
    station = prediction.S

    if !@stations[station['@'].Code]
      @addStation station

    for platform in station.P
      @addTrains platform.T

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

  addTrains: (trains) ->
    for train in trains
      trainKey = "#{train['@'].LCID}:#{train['@'].SetNo}:#{train['@'].TripNo}"

      if !@trains[trainKey]
        @addTrain trainKey, train
  
  addTrain: (trainKey, train) ->
    @trains[trainKey] =
      lcid: train['@'].LCID
      setNumber: train['@'].SetNo
      tripNumber: train['@'].TripNo
      currentTrackCode: train['@'].TrackCode

  getStations: () ->
    @stations

  getTrains: () ->
    @trains

module.exports = LineTopologyGatherer
