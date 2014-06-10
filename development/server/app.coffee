###
Module dependencies.
###
express          = require("express")
cookieParser     = require("cookie-parser")
compress         = require("compression")
session          = require("express-session")
bodyParser       = require("body-parser")
logger           = require("morgan")
errorHandler     = require("errorhandler")
csrf             = require("lusca").csrf()
methodOverride   = require("method-override")
_                = require("lodash")
MongoStore       = require("connect-mongo")(session: session)
flash            = require("express-flash")
path             = require("path")
mongoose         = require("mongoose")
passport         = require("passport")
expressValidator = require("express-validator")

###
Routers
###
userRouter     = require("./routes/user")

###
Controllers (route handlers).
###
homeController = require("./controllers/home")

###
API keys and Passport configuration.
###
secrets        = require("./config/secrets")
config         = require("./config/config")
passportConf   = require("./config/passport")

###
Create Express server.
###
app = express()

###
Connect to MongoDB.
###
mongoose.connect config.db
mongoose.connection.on "error", ->
  console.error "MongoDB Connection Error. Make sure MongoDB is running."
  return

hour = 3600000
day = hour * 24
week = day * 7

###
CSRF whitelist.
###
csrfExclude = [
  "/api/"
]

###
Express configuration.
###
app.set "port", process.env.PORT or 3000

app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')
app.use compress()
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use expressValidator()
app.use methodOverride()
app.use cookieParser()
app.use session(
  secret: secrets.sessionSecret
  store: new MongoStore(
    url: config.db
    auto_reconnect: true
  )
)
app.use passport.initialize()
app.use passport.session()
app.use flash()
app.use (req, res, next) ->
  
  # CSRF protection.
  return next()  if _.some(csrfExclude, (item) -> return ~req.path.indexOf(item) )
  csrf req, res, next
  return

app.use (req, res, next) ->
  
  # Make user object available in templates.
  res.locals.user = req.user
  next()
  return

app.use (req, res, next) ->
  
  # Remember original destination before login.
  path = req.path.split("/")[1]
  return next()  if /auth|login|logout|signup|img|fonts|favicon/i.test(path)
  req.session.returnTo = req.path
  next()
  return

app.use express.static(path.join(__dirname, "../public"),
  maxAge: week
)

###
Main routes.
###
app.use('/api/user', userRouter)

###
500 Error Handler.
###
app.use errorHandler()

###
Start Express server if not testing.
###
if process.env.NODE_ENV != 'test'
  app.listen app.get("port"), ->
    console.log "Express server listening on port %d in %s mode", app.get("port"), app.get("env")
    return

module.exports = app