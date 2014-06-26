_          = require("lodash")
async      = require("async")
crypto     = require("crypto")
nodemailer = require("nodemailer")
passport   = require("passport")
User       = require("../models/User")
secrets    = require("../config/secrets")
config     = require("../config/config")
mailer     = require("./mailer")
swig       = require('swig')
path       = require("path")


UserNotFoundError = (message) ->
  @name = "UserNotFoundError"
  @message = (message || "")
  return

UserNotFoundError.prototype = new Error()

###
POST /signin/
Sign in using email and password.
@param email
@param password
###
exports.postLogin = (req, res, next) ->
  req.assert("email", "Email is not valid").isEmail()
  req.assert("password", "Password cannot be blank").notEmpty()
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {'validationErrors': validationErrors})
    return
  passport.authenticate("local", (err, user, info) ->
    return next(err) if err

    unless user
      res.json(403, {"error": info.message})
      return

    req.logIn user, (err) ->
      return next(err) if err
      res.json(200, {"user": user})
      return

    return
  ) req, res, next
  return

###
GET /current/
###
exports.isLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    res.json(200, {"user": req.user})
  else
    res.json(403, {})

###
POST /signout/
Log out.
###
exports.logout = (req, res) ->
  req.logout()
  res.json(200, {"message": "Logged out"})
  return


###
POST /signup/
Create a new local account.
@param email
@param password
###
exports.postSignup = (req, res, next) ->
  req.assert("email", "Email is not valid").isEmail()
  req.assert("password", "Password must be at least 4 characters long").len 4
  validationErrors = req.validationErrors()

  if validationErrors
    console.error(validationErrors)
    validationErrors[0].message = validationErrors[0].msg
    delete validationErrors[0].msg
    res.json(400, { ok: false, message: validationErrors[0].message, error: validationErrors[0] })
    return

  user = new User(
    email: req.body.email
    profile: {name: req.body.name || ""}
    password: req.body.password
  )

  User.findOne
    email: req.body.email
  , (err, existingUser) ->
    if existingUser
      console.error("Account with that email address already exists: " + req.body.email)
      res.json(400, { ok: false, message: "Account with that email address already exists: " + req.body.email })
      return

      # req.flash "errors",
      #   msg: "Account with that email address already exists."

    user.save (err) ->
      return next(err) if err
      req.logIn user, (err) ->
        return next(err) if err
        res.json(202, { ok: true, message: "User " + user.email + " created.", user: user })
        return

      return

    return

  return

###
POST /forgot/
Create a random token, then the send user an email with a reset link.
@param email
###
exports.postForgot = (req, res, next) ->
  req.assert("email", "Please enter a valid email address.").isEmail()
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {"validationErrors": validationErrors})
    return

  async.waterfall [
    (done) ->
      crypto.randomBytes 16, (err, buf) ->
        token = buf.toString("hex")
        done err, token
        return

    (token, done) ->
      User.findOne email: req.body.email.toLowerCase()
      , (err, user) ->
        if not user
          done(new UserNotFoundError("Can't find email: " + req.body.email))
        else
          user.resetPasswordToken = token
          user.resetPasswordExpires = Date.now() + 3600000 # 1 hour
          user.save (err) ->
            done err, token, user
            return
        return

    (token, user, done) ->
      if not (process.env.NODE_ENV in ['dev', 'test'])
        smtpTransport = mailer.createSmtpTransport()
        mailOptions =
          to: user.email
          from: config.mailer.defaulFromAddress
          subject: "Reset your password "
          text: swig.compileFile(path.join(__dirname, '../views/email/forgot/text.swig'))({'reset_url': req.host + '/reset_password', 'token': token})

        smtpTransport.sendMail mailOptions, (err) ->
          done err, token
      else
        done null, token

  ], (err, token) ->

    if err instanceof UserNotFoundError
      res.json(404, {"error": err.message})
      return
    else if err then return next(err)

    if process.env.NODE_ENV == "test"
      res.json(200, {"message": "Password reset email sent to " + req.body.email, "token": token})
    else
      console.log("Token: " + token)
      res.json(200, {"message": "Password reset email sent to " + req.body.email})
    return

  return

###
POST /reset/
Process the reset password request.
@param token
@param password
###
exports.postReset = (req, res, next) ->
  req.assert("password", "Password must be at least 4 characters long.").len 4
  req.assert("token", "Token can't be empty").len 1
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {"validationErrors": validationErrors})
    return

  User.findOne(resetPasswordToken: req.body.token).where("resetPasswordExpires").gt(Date.now()).exec (err, user) ->
    return next(err) if err
    if not user
      res.json(404, {error: "Can't find token: " + req.body.token})
      return
    else
      user.password = req.body.password
      user.resetPasswordToken = `undefined`
      user.resetPasswordExpires = `undefined`
      user.save (err) ->
        return next(err) if err
        req.logIn user, (err) ->
          return next(err) if err
          res.json(200, {"message": "Password updated."})
          return
        return
      return
  return


exports.getUser = (req, res, next) ->
  req.assert("email", "You need to say email of the user you want to get").isEmail()
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {"validationErrors": validationErrors})
    return

  if req.isAuthenticated()
    if req.user.email == req.params.email
      res.json(200, {"user": req.user})
      return

    if req.user.isAdmin
      User.findOne {email: req.params.email}, (err, user) ->
        return next(err) if err
        if user
          res.json(200, {"user": user})
        else
          res.json(404, {error: "Can't find user with email: " + req.params.email})
      return

  res.json(403, {})

exports.patchUser = (req, res, next) ->
  req.assert("email", "You need to say email of the user you want to change").isEmail()
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {"validationErrors": validationErrors})
    return

  if req.isAuthenticated()
    if req.user.email == req.params.email or req.user.isAdmin

      if 'isAdmin' of req.body and not req.user.isAdmin
        return res.json(403, {"error": "Only admin can make new admins."})

      User.findOne {email: req.params.email}, (err, user) ->
        return next(err) if err
        return  res.json(404, {error: "Can't find user with email: " + req.params.email}) if not user
        user.updateDocument req.body
        , (err, user) ->
          return next(err) if err
          return res.json(200, {"user": user})

      return
  res.json(403, {})


exports.deleteUser = (req, res, next) ->
  req.assert("email", "You need to say email of the user you want to remove").isEmail()
  validationErrors = req.validationErrors()
  if validationErrors
    res.json(400, {"validationErrors": validationErrors})
    return

  if req.isAuthenticated()
    if req.user.email == req.params.email or req.user.isAdmin
      User.remove {email: req.params.email}, (err) ->
        return next(err) if err
        req.logout() if not req.user.isAdmin
        res.json(200, {"message": "Account " + req.params.email + " has been removed."})
      return
  res.json(403, {})

###
~~~~~~~~~~~~~~~~~~~~ Changed to API until this point ~~~~~~~~~~~~~~~~~~~~~~~
###


###
POST /account/profile
Update profile information.
###
exports.postUpdateProfile = (req, res, next) ->
  User.findById req.user.id, (err, user) ->
    return next(err)  if err
    user.email = req.body.email or ""
    user.profile.name = req.body.name or ""
    user.profile.gender = req.body.gender or ""
    user.profile.location = req.body.location or ""
    user.profile.website = req.body.website or ""
    user.save (err) ->
      return next(err)  if err
      req.flash "success",
        msg: "Profile information updated."

      res.redirect "/account"
      return

    return

  return


###
POST /account/password
Update current password.
@param password
###
exports.postUpdatePassword = (req, res, next) ->
  req.assert("password", "Password must be at least 4 characters long").len 4
  req.assert("confirmPassword", "Passwords do not match").equals req.body.password
  errors = req.validationErrors()
  if errors
    req.flash "errors", errors
    return res.redirect("/account")
  User.findById req.user.id, (err, user) ->
    return next(err)  if err
    user.password = req.body.password
    user.save (err) ->
      return next(err)  if err
      req.flash "success",
        msg: "Password has been changed."

      res.redirect "/account"
      return

    return

  return

###
GET /account/unlink/:provider
Unlink OAuth provider.
@param provider
###
exports.getOauthUnlink = (req, res, next) ->
  provider = req.params.provider
  User.findById req.user.id, (err, user) ->
    return next(err)  if err
    user[provider] = `undefined`
    user.tokens = _.reject(user.tokens, (token) ->
      token.kind is provider
    )
    user.save (err) ->
      return next(err)  if err
      req.flash "info",
        msg: provider + " account has been unlinked."

      res.redirect "/account"
      return

    return

  return
