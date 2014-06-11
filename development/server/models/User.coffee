mongoose = require("mongoose")
bcrypt = require("bcrypt-nodejs")
crypto = require("crypto")

###
Email is the unique field used to identify and manage users.
###

userSchema = new mongoose.Schema(
  email:
    type: String
    unique: true
    lowercase: true

  password: String
  instagram: String
  tokens: Array
  isAdmin:
    type: Boolean
    default: false
  profile:
    name:
      type: String
      default: ""

    gender:
      type: String
      default: ""

    location:
      type: String
      default: ""

    website:
      type: String
      default: ""

    picture:
      type: String
      default: ""

  resetPasswordToken: String
  resetPasswordExpires: Date
)

###
Hash the password for security.
"Pre" is a Mongoose middleware that executes before each user.save() call.
###
userSchema.pre "save", (next) ->
  user = this
  return next()  unless user.isModified("password")
  bcrypt.genSalt 5, (err, salt) ->
    return next(err)  if err
    bcrypt.hash user.password, salt, null, (err, hash) ->
      return next(err)  if err
      user.password = hash
      next()
      return

    return

  return

userSchema.methods.toJSON = () ->
  obj = @toObject()
  delete obj.password
  return obj

###
Validate users password.
Used by Passport-Local Strategy for password validation.
###
userSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, @password, (err, isMatch) ->
    return cb(err)  if err
    cb null, isMatch
    return

  return

userSchema.methods.updateDocument = (data, done) ->
  if data.password?
    @password = data.password
    delete data.password
    @save (err, user) ->
      return done(err, user) if err
      @update { $set: data }, {}, (err, numAffected, rawResponse) ->
        return done(err, null) if err
        done(null, @)
  else
    @update { $set: data }, {}, (err, numAffected, rawResponse) ->
      return done(err, null) if err
      done(null, @)

###
Get URL to a users gravatar.
Used in Navbar and Account Management page.
###
userSchema.methods.gravatar = (size) ->
  size = 200  unless size
  return "https://gravatar.com/avatar/?s=" + size + "&d=retro"  unless @email
  md5 = crypto.createHash("md5").update(@email).digest("hex")
  "https://gravatar.com/avatar/" + md5 + "?s=" + size + "&d=retro"

module.exports = mongoose.model("User", userSchema)