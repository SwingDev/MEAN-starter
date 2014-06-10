process.env.NODE_ENV = "test"

request = require("supertest")
assert  = require('chai').assert
app     = require("../app")
expect  = require('chai').expect

agent = request.agent(app) # agent should persist sessions

describe "Create accunt and sign in", ->
  user_data = {"email": "user_test@example.com", "password": "1234"}

  it "POST /api/user/signup/ should return 202 CREATED", (done) ->
    agent.post("/api/user/signup/")
         .send(user_data)
         .expect 202, done
    return

  it "GET /api/user/current/ should return 200 OK", (done) ->
    agent.get("/api/user/current/")
         .expect 200, done
    return

  it "POST /api/user/signout/ should return 200 OK", (done) ->
    agent.post("/api/user/signout/")
         .expect 200, done
    return

  it "GET /api/user/current/ should return 401", (done) ->
    agent.get("/api/user/current/")
         .expect 401, done
    return

  it "POST /api/user/signin/ should return 200 OK", (done) ->
    agent.post("/api/user/signin/")
         .send(user_data)
         .expect 200, done
    return

  it "GET /api/user/current/ should return 200 OK", (done) ->
    agent.get("/api/user/current/")
         .expect 200, done
    return

  return

describe "Frogotten password flow", ->
  user_data = {"email": "marcin.mincer+mean@gmail.com", "password": "1234"}
  token = null
  it "Should not find the user first", (done) ->
    agent.post("/api/user/forgot/")
         .send({email: user_data.email})
         .expect 404, done
    return

  it "Add new user user_test_mail@example.com", (done) ->
    agent.post("/api/user/signup/")
         .send(user_data)
         .expect 202, done
    return

  it "POST /api/user/forgot/ should return 200 OK", (done) ->
    agent.post("/api/user/forgot/")
          .send({email: user_data.email})
          .expect 200
          .end (err, res) ->
            return done(err) if err
            expect(res.body).to.have.property('token')
            token = res.body.token
            done()
    return

  it "POST /api/user/reset/ should change password and return 200 OK", (done) ->
    agent.post("/api/user/reset/")
         .send({token: token, password: "new_password"})
         .expect 200, done
    return

  it "POST /api/user/reset/ should not be able to change password again", (done) ->
    agent.post("/api/user/reset/")
         .send({token: token, password: "new_password"})
         .expect 404, done
    return

  it "POST /api/user/signout/ should return 200 OK", (done) ->
    agent.post("/api/user/signout/")
         .expect 200, done
    return

  it "POST /api/user/signin/ should not be able to log in using old password", (done) ->
    agent.post("/api/user/signin/")
         .send(user_data)
         .expect 403, done
    return

  it "POST /api/user/signin/ should be able to log in using new password", (done) ->
    agent.post("/api/user/signin/")
         .send({"email": "marcin.mincer+mean@gmail.com", "password": "new_password"})
         .expect 200, done
    return
  
  return
