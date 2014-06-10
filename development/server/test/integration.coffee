process.env.NODE_ENV = "test"
request = require("supertest")
app = require("../app")
agent = request.agent(app) # agent should persist sessions

describe "POST /api/user/signup/", ->
  it "should return 202 CREATED", (done) ->
    agent.post("/api/user/signup/")
         .send({"email": "user_test@example.com", "password": "1234"})
         .expect 202, done
    return
  return
