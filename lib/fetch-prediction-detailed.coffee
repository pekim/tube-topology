request = require 'request'
xml2js = require 'xml2js'

###
  Fetch the prediction detail for a station.

  @param lineCode       1 character, representing the line.
  @param stationCode    3 character station code
  @param callback       will be called on success or failure
###

module.exports = (lineCode, stationCode, callback) ->
  url = "http://cloud.tfl.gov.uk/TrackerNet/PredictionDetailed/#{lineCode}/#{stationCode}"

  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      # Remove UTF-16 Big-Endian BOM, which the sax parser can't cope with.
      body = body.slice 1

      parser = new xml2js.Parser
      parser.addListener 'end', (prediction) ->
        callback undefined, prediction
      parser.addListener 'error', (error) ->
        console.log 'Parse XML error', error, body
        callback error

      parser.parseString body

    else
      console.log "Failed to get line summary: #{response.statusCode}, #{error}"
      callback error
