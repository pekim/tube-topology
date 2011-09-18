request = require 'request'
xml2js = require 'xml2js'

module.exports = (url, callback) ->
  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      parser = new xml2js.Parser
      parser.addListener 'end', (object) ->
        callback undefined, object

      # Remove UTF-16 Big-Endian BOM, which sax can't cope with.
      body = body.slice 1

      parser.parseString body

    else
      callback error
