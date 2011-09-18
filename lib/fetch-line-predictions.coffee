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
module.exports = (lineCode, stationCodes, period, callback) ->
  timeoutDelay = period / stationCodes.length
  stop = false
  stationIndex = 0

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

  fetch()
