process.env.NODE_ENV = "test"
request = require("supertest")
app = require("../app")

describe "GET /", ->
  it "should return 200 OK", (done) ->
    request.agent(app).get("/").expect 200, done
    return
  return

describe "GET /login", ->
  it "should return 200 OK", (done) ->
    request.agent(app).get("/login").expect 200, done
    return
  return

describe "GET /signup", ->
  it "should return 200 OK", (done) ->
    request.agent(app).get("/signup").expect 200, done
    return
  return
