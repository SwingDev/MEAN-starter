_ = require("lodash")
passport = require("passport")
LocalStrategy = require("passport-local").Strategy
User = require("../models/User")
secrets = require("./secrets")

passport.serializeUser (user, done) ->
  done null, user.id
  return

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    # make sure that password doesn't leave the server when returning req.user
    if user then user.password = 'this_is_secret'
    done err, user
    return

  return


# Sign in using Email and Password.
passport.use new LocalStrategy(
  usernameField: "email"
, (email, password, done) ->
  User.findOne
    email: email
  , (err, user) ->
    unless user
      return done(null, false,
        message: "Email " + email + " not found"
      )
    user.comparePassword password, (err, isMatch) ->
      if isMatch
        done null, user
      else
        done null, false,
          message: "Invalid email or password."


    return

  return
)

###
OAuth Strategy Overview

- User is already logged in.
- Check if there is an existing account with a <provider> id.
- If there is, return an error message. (Account merging not supported)
- Else link new OAuth account with currently logged-in user.
- User is not logged in.
- Check if it's a returning user.
- If returning user, sign in and we are done.
- Else check if there is an existing account with user's email.
- If there is, return an error message.
- Else create a new account.
###

# Login Required middleware.
exports.isAuthenticated = (req, res, next) ->
  return next()  if req.isAuthenticated()
  res.redirect "/login"
  return


# Authorization Required middleware.
exports.isAuthorized = (req, res, next) ->
  provider = req.path.split("/").slice(-1)[0]
  if _.find(req.user.tokens,
    kind: provider
  )
    next()
  else
    res.redirect "/auth/" + provider
  return