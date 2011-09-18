fetchDetail = require './fetch-prediction-detailed'

###
  Fetch the prediction details for stations on a line.

  @param lineCode       1 character, representing the line.
  @param callback       will be called on success or failure
###
module.exports = (lineCode, callback) ->
  fetchDetail lineCode, 'OXC', (error, prediction) ->
    callback error, prediction

  fetchDetail lineCode, 'VIC', (error, prediction) ->
    callback error, prediction
