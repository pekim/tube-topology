request = require 'request'

module.exports = (url, callback) ->
  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      callback undefined, body
    else
      callback error
