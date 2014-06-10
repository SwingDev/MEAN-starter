process.env.NODE_ENV = "test"
request = require("supertest")
app = require("../app")

describe "POST /api/user/signup", ->
  it "should return 200 OK", (done) ->
    request.agent(app).get("/").expect 200, done
    return
  return
