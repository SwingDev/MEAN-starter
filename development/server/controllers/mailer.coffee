config     = require("../config/config")
nodemailer = require("nodemailer")


exports.createSmtpTransport = () ->
  return nodemailer.createTransport("SMTP",
          service: "Mailgun"
          auth:
            user: config.mailgun.user
            pass: config.mailgun.password
        )