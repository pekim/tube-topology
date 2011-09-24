express = require 'express'
fs = require 'fs'
fetch = require './fetch-line-predictions'
LineTopologyGatherer = require './line-topology-gather'

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

gatherer = new LineTopologyGatherer

# Routes
app.get '/', (req, res) ->
  res.render 'index', {
    title: 'Bakerloo line'
    gatherer: gatherer
  }

line = JSON.parse(fs.readFileSync __dirname + '/../data/bakerloo.stations.json', 'ascii')
stationCodes = (code for code, dummy of line.stations)
fetch line.code, stationCodes, 30 * 1000, (error, stationPrediction) ->
  gatherer.addPrediction stationPrediction

  false

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
