express = require 'express'
#fetch = require './fetch-line-predictions'
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

gatherer = new LineTopologyGatherer 'B', 'Bakerloo'

# Routes
app.get '/', (req, res) ->
  res.render 'index', {
    title: 'Bakerloo line'
    gatherer: gatherer
  }

#fetch 'B', 30 * 1000, (error, stationPrediction) ->
#  if !error
#    gatherer.addPrediction stationPrediction
#
#  false

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
