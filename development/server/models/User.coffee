mongoose = require("mongoose")
bcrypt   = require("bcrypt-nodejs")
crypto   = require("crypto")
_        = require("lodash")
utils    = require("./utils")

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

###
Thanks this method the model will acutally be properly updated what includes:
* Running validations
* Running mongoose middlewars
* Only updating existing paths, ignoring other stuff
* Going deep into nested objects
###
userSchema.methods.updateDocument = (data, done) ->
  for k,v of userSchema.paths
    # Don't assing mongo internal properties (start with '_') and assing only 
    # properties that are in the original model
    if String(k).charAt(0) != '_' and utils.getAttrByString(data, String(k))? 
      eval("this.#{k} = data.#{k};")      
  @save (err, user) =>
    return done(err, user) if err
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