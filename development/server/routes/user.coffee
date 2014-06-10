express = require('express')
userController = require("../controllers/user")


router = express.Router()

router.post('/signup', userController.postSignup)

module.exports = router