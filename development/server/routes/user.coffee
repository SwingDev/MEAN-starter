express = require('express')
userController = require("../controllers/user")


router = express.Router()

router.post('/signup/', userController.postSignup)
router.post('/signin/', userController.postLogin)
router.post('/signout/', userController.logout)
router.post('/forgot/', userController.postForgot)

router.get('/current/', userController.isLoggedIn)
module.exports = router