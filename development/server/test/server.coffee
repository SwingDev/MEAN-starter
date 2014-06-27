process.env.NODE_ENV = "test"

request = require("supertest")
assert  = require('chai').assert
app     = require("../app")
expect  = require('chai').expect
config  = require("../config/config")

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

  it "GET /api/user/current/ should return 403", (done) ->
    agent.get("/api/user/current/")
         .expect 403, done
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

describe "Changing user data", ->
  user_data1 = {"email": "test.user+1@gmail.com", "password": "1234"}
  user_data2 = {"email": "test.user+2@gmail.com", "password": "1234"}

  it "Add new user test.user+1@example.com", (done) ->
    agent.post("/api/user/signup/")
         .send(user_data1)
         .expect 202, done
    return

  it "New user should be able to change profile data", (done) ->
    agent.patch("/api/user/" + user_data1.email + "/")
        .send({"profile": {"gender": "male"}})
        .expect 200
        .end (err, res) ->
          expect(res.body["user"]["profile"]["gender"]).to.equal("male")
          done(err)
    return

  it "New user shouldn't be able to make himself admin", (done) ->
    agent.patch("/api/user/" + user_data1.email + "/")
         .send({"isAdmin": true})
         .expect 403, done
    return

  it "New user shouldn't be able to add new keys to model", (done) ->
    agent.patch("/api/user/" + user_data1.email + "/")
        .send({"new_key": "new_key"})
        .expect 200
        .end (err, res) ->
          expect(res.body["user"]).not.to.have.property('new_key')
          done(err)
    return

  it "New user should be able to change password", (done) ->
    agent.patch("/api/user/" + user_data1.email + "/")
        .send({"password": "new_password"})
        .expect 200
        .end (err, res) ->
          return done(err) if err
          agent.post("/api/user/signout/")
              .expect 200
              .end (err, res) ->
                return done(err) if err
                agent.post("/api/user/signin/")
                    .send({"email": user_data1.email, "password": "new_password"})
                     .expect 200, done
    return

  it "Add second new user test.user+2@example.com and signout", (done) ->
    agent.post("/api/user/signup/")
        .send(user_data2)
        .expect 202
        .end (err, res) ->
          done(err) if err
          agent.post("/api/user/signout/")
          .expect 200, done
    return

  it "Sign in as new user and you should not be able to modify second user", (done) ->
    agent.post("/api/user/signin/")
        .send({"email": user_data1.email, "password": "new_password"})
        .expect 200
        .end (err, res) ->
          done(err) if err
          agent.patch("/api/user/" + user_data2.email + "/")
          .send({"profile.gender": "female"})
          .expect 403, done
    return


  return
