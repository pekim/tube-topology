require 'dojo-node'

fetch = require './fetch-line-predictions'
fs = require 'fs'
jsonRef = dojo.require 'dojox.json.ref'

class LineTopologyGatherer
  constructor: (@lineCode, @lineName) ->
    @persistentFilename = "persist/#{lineCode}"
    @stations = {}
    @platformsByTrackCode = {}
    @paths = {}
    @trains = {}

    @load()
    setInterval @save, 30 * 1000

  load: =>
    fs.readFile @persistentFilename, 'utf8', (error, data) =>
      if !error
        loadedGatherer = jsonRef.fromJson data
        
        @stations = loadedGatherer.stations
        @platformsByTrackCode = loadedGatherer.platformsByTrackCode
        @paths = loadedGatherer.paths
        @trains = loadedGatherer.trains
    
        @startFetching()
      else
        console.log "Error reading JSON representation of LineTopologyGatherer: #{error}"

  save: =>
    json = jsonRef.toJson @, true

    fs.writeFile @persistentFilename, json, 'utf8', (error) ->
      if error
        console.log "Error writing JSON representation of LineTopologyGatherer: #{error}"

  startFetching: ->
    fetch @lineCode, 30 * 1000, (error, stationPrediction) =>
      if !error
        @addPrediction stationPrediction

      false

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

  getLineCode: () ->
    @lineCode

  getLineName: () ->
    @lineName

  getStations: () ->
    @stations

  getPlatformByTrackCode: (trackCode) ->
    @platformsByTrackCode[trackCode]

  getTrains: () ->
    @trains

  getPaths: () ->
    @paths

module.exports = LineTopologyGatherer
