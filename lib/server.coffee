express = require 'express'

app = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/../views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/../public')

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get '/', (req, res) ->
  res.render 'index', {
    title: 'Express'
  }

fs = require 'fs'
fetch = require './fetch-line-predictions'
LineTopologyGatherer = require('./line-topology-gather')

gatherer = new LineTopologyGatherer
line = JSON.parse(fs.readFileSync __dirname + '/../data/bakerloo.stations.json', 'ascii')
stationCodes = (code for code, dummy of line.stations)
fetch line.code, stationCodes, 30 * 1000, (error, stationPrediction) ->
  #console.log stationPrediction
  gatherer.addPrediction stationPrediction

  false

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
