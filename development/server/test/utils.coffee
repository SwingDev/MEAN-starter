"use strict"

#
#* Modified from https://github.com/elliotf/mocha-mongoose
#
# ensure the NODE_ENV is set to 'test'
# this is helpful when you would like to change behavior when testing
process.env.NODE_ENV = "test"
config = require("../config/config")
mongoose = require("mongoose")


before (done) ->
  clearDB = ->
    for i of mongoose.connection.collections
      mongoose.connection.collections[i].remove((err, numberOfRemovedDocs) -> )
    done()
  reconnect = ->
    mongoose.connect config.db, (err) ->
      throw err if err
      clearDB()
    return
  checkState = ->
    switch mongoose.connection.readyState
      when 0
        reconnect()
      when 1
        clearDB()
      else
        process.nextTick checkState
    return
  checkState()
  return

after (done) ->
  mongoose.disconnect()
  done()
