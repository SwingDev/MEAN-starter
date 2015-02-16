appconfig = require '../../../../appconfig'

module.exports =
  db: process.env.MONGODB or 'mongodb://localhost:27017/'+appconfig.id
