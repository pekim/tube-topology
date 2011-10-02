request = require 'request'
xml2js = require 'xml2js'
fetchDetail = require './fetch-prediction-detailed'

###
  Fetch the prediction details for stations on a line.

  @param lineCode       1 character, representing the line.
  @param stationCodes   array of 3 character codes for the stations.
  @param period         the approximate number of milliseconds that each station's
                        detail can be fetched.
  @param callback       will be called on success or failure.
                        If it returns a truthy value, fetching will stop.
###
module.exports = (lineCode, period, callback) ->
  lineSummaryUrl = "http://cloud.tfl.gov.uk/TrackerNet/PredictionSummary/#{lineCode}"
  stationCodes = []
  timeoutDelay = 0
  stop = false
  stationIndex = 0

  request lineSummaryUrl, (error, response, body) ->
    if !error and response.statusCode == 200
      # Remove UTF-16 Big-Endian BOM, which the sax parser can't cope with.
      body = body.slice 1

      parser = new xml2js.Parser
      parser.addListener 'end', (lineSummary) ->
        extractStationCodes(lineSummary)
      parser.addListener 'error', (error) ->
        console.log 'Parse XML error', error, body

      parser.parseString body

    else
      console.log "Failed to get line summary: #{response.statusCode}, #{error}"

  extractStationCodes = (lineSummary) ->
    for station in lineSummary.S
      stationCodes.push station['@'].Code

    timeoutDelay = period / stationCodes.length
    fetch()

  fetch = () ->
    stationCode = stationCodes[stationIndex]
    fetchDetail lineCode, stationCode, (error, prediction) ->
      stop = callback error, prediction

    # Next station
    stationIndex++
    if stationIndex >= stationCodes.length
      stationIndex = 0
    
    if (!stop)
      setTimeout fetch, timeoutDelay
