express = require('express')
userController = require("../controllers/user")


router = express.Router()

router.post('/signup', userController.postSignup)
router.post('/signin', userController.postLogin)

module.exports = router