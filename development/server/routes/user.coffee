express = require('express')
userController = require("../controllers/user")


router = express.Router()

router.post('/signup/', userController.postSignup)
router.post('/signin/', userController.postLogin)
router.get('/checklogin/', userController.isLoggedIn)

module.exports = router