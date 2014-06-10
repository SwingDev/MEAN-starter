express = require('express')
userController = require("../controllers/user")


router = express.Router()

router.post('/signup/', userController.postSignup)
router.post('/signin/', userController.postLogin)
router.post('/signout/', userController.logout)
router.post('/forgot/', userController.postForgot)
router.post('/reset/', userController.postReset)

router.get('/current/', userController.isLoggedIn)
module.exports = router