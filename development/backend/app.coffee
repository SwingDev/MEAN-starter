###
Module dependencies.
###
express          = require 'express'
path             = require 'path'
errorHandler     = require 'errorhandler'
mongoose         = require 'mongoose'
helmet           = require 'helmet'
flash            = require 'express-flash'
passport         = require 'passport'
bodyParser       = require 'body-parser'
expressValidator = require 'express-validator'
cookieParser     = require 'cookie-parser'
csrf             = require 'csurf'

###
External configuration files.
###
config = require './config/config'

###
Connect to MongoDB.
###
mongooseKwargs = {}
if process.env.NODE_ENV is 'dev'
  mongooseKwargs['server'] = { poolSize: 1 }

mongoose.connect config.db, mongooseKwargs
mongoose.connection.on 'error', ->
  console.error "MongoDB connection error. Make sure MongoDB is running."
  return

###
Create express server.
###
app = express()

hour = 3600000
day  = hour * 24
week = day * 7

###
Express configuration.
###
app.set 'port', process.env.PORT or 3000

app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

app.use expressValidator()

app.use cookieParser()

app.use flash()

app.use helmet.xframe('deny')
app.use helmet.hidePoweredBy()
app.use helmet.nocache()
app.use helmet.crossdomain()

scrfValue = (req) ->
  token = (req.body and req.body._csrf) or (req.query and req.query._csrf) or (req.headers["x-csrf-token"]) or (req.headers["x-xsrf-token"])
  token
if process.env.NODE_ENV == 'stage' or process.env.NODE_ENV == 'production'
  app.use csrf({value: csrfValue})
  app.use (req, res, next) ->
    res.cookie "XSRF-TOKEN", req.csrfToken()
    res.locals.csrftoken = req.csrfToken()
    next()
    return

# Static files serve.
app.use express.static(path.join(__dirname, '../frontend'),
  maxAge: week
)

# Error handler.
app.use errorHandler()

###
Start express server.
###
app.listen app.get('port'), ->
  console.log "Express server listening on port %d in %s mode", app.get("port")
  return

module.exports = app
