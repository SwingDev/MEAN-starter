chai = require("chai")
should = chai.should()
User = require("../models/User")

process.env.NODE_ENV = "test"
config = require("../config/config")
mongoose = require("mongoose")


before (done) ->
  clearDB = ->
    for i of mongoose.connection.collections
      mongoose.connection.collections[i].remove((err, numberOfRemovedDocs) -> )

  if mongoose.connection.readyState == 0
    console.log('Trying to connect to mongoDB... ')
    mongoose.connect config.db, (err) ->
      throw err if err
      clearDB()
      done()
  else
    clearDB()
    done()

  return

after (done) ->
  mongoose.disconnect()
  done()


describe "User Model", ->
  it "should create a new user", (done) ->
    user = new User(
      email: "test@gmail.com"
      password: "password"
    )
    user.save (err) ->
      return done(err)  if err
      done()
      return

    return

  it "should not create a user with the unique email", (done) ->
    user = new User(
      email: "test@gmail.com"
      password: "password"
    )
    user.save (err) ->
      err.code.should.equal 11000
      done()
      return
    return

  it "should find user by email", (done) ->
    User.findOne
      email: "test@gmail.com"
    , (err, user) ->
      return done(err)  if err
      user.email.should.equal "test@gmail.com"
      done()
      return

    return

  it "should delete a user", (done) ->
    User.remove
      email: "test@gmail.com"
    , (err) ->
      return done(err)  if err
      done()
      return

    return

  return

before (done) -> done()

after (done) -> done()
