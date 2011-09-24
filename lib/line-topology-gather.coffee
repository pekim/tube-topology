class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @paths = {}
    @trains = {}

  addPrediction: (prediction) ->
    time = Date.parse(prediction.WhenCreated)
    station = prediction.S

    if !@stations[station['@'].Code]
      @addStation station

    for platform in station.P
      if platform.T
        @processTrains platform.T, time

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

  processTrains: (trains, time) ->
    for newTrain in trains
      trainKey = "#{newTrain['@'].LCID}:#{newTrain['@'].SetNo}"

      if !@trains[trainKey]
        @addTrain trainKey, newTrain, time
      else
        train = @trains[trainKey]
        if time > train.time
          newTrackCode = newTrain['@'].TrackCode
          if newTrackCode != train.trackCode
            @addPath train.trackCode, newTrackCode

            train.time = time
            train.trackCode = newTrackCode
  
  addTrain: (trainKey, train, time) ->
    @trains[trainKey] =
      time: time
      lcid: train['@'].LCID
      setNumber: train['@'].SetNo
      tripNumber: train['@'].TripNo
      trackCode: train['@'].TrackCode

  addPath: (fromTrackCode, toTrackCode) ->
    if !@paths[fromTrackCode]
      @paths[fromTrackCode] = []

    if @paths[fromTrackCode].indexOf(toTrackCode) == -1
      !@paths[fromTrackCode].push(toTrackCode)

  getStations: () ->
    @stations

  getTrains: () ->
    @trains

  getPaths: () ->
    @paths

module.exports = LineTopologyGatherer
