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
      parser = new xml2js.Parser
      parser.addListener 'end', (object) ->
        callback undefined, object

      # Remove UTF-16 Big-Endian BOM, which the sax parser can't cope with.
      body = body.slice 1

      parser.parseString body

    else
      callback error
