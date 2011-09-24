class LineTopologyGatherer
  constructor: ->
    @stations = {}
    @platformsByTrackCode = {}
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

    newStation =
      code: station['@'].Code
      name: station['@'].N
      platforms: platforms

    @stations[newStation.code] = newStation

    for platform in station.P
      platformName = platform['@'].N
      platformNumber = platform['@'].Num
      platformTrackCode = platform['@'].TrackCode

      platforms[platformNumber] = 
        station: newStation
        name: platformName
        number: platformNumber
        trackCode: platformTrackCode

      @platformsByTrackCode[platformTrackCode] = platforms[platformNumber]

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
      console.log "#{fromTrackCode} -> #{toTrackCode}"
      !@paths[fromTrackCode].push(toTrackCode)

  getStations: () ->
    @stations

  getPlatformByTrackCode: (trackCode) ->
    @platformsByTrackCode[trackCode]

  getTrains: () ->
    @trains

  getPaths: () ->
    @paths

module.exports = LineTopologyGatherer
