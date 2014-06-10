secrets    = require("../config/secrets")
config     = require("../config/config")
nodemailer = require("nodemailer")


exports.createSmtpTransport = () ->
  return nodemailer.createTransport("SMTP",
          service: "Mailgun"
          auth:
            user: secrets.mailgun.user
            pass: secrets.mailgun.password
        )