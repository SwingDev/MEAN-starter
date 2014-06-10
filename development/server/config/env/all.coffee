module.exports =
  db: process.env.MONGODB or "mongodb://localhost:27017/mean"
  mailer:
    defaultFromAddres: "postmaster@blade.mailgun.org"