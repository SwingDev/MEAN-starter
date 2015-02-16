# Utilize Lo-Dash utility library
_ = require 'lodash'

# Load configurations
# Set the node environment variable if not set before
process.env.NODE_ENV = if process.env.NODE_ENV in ['dev', 'production', 'staging', 'test'] then process.env.NODE_ENV else 'dev'

# Extend the base configuration in all.js with environment
# specific configuration
module.exports = _.extend(require('./env/all'), require('./env/'+process.env.NODE_ENV) or {})
