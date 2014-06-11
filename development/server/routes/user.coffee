express = require('express')
userController = require("../controllers/user")


router = express.Router()

###
Creat account. Logs in automatically.
Sessions in cookie, persisted in MongoDB
@param name
@param password (required)
@param email (required)
@returns {json} user profile
###
router.post('/signup/', userController.postSignup)

###
Log in
@param email
@param password
###
router.post('/signin/', userController.postLogin)

###
Log out, no params
###
router.post('/signout/', userController.logout)

###
Forgot password. Sends email with token. In testing mode it will also return the token.
@param email
###
router.post('/forgot/', userController.postForgot)

###
Reset password. Provide new password and token that you got in email.
Logs in automatically.
@param password - new password you want to set
@param token
###
router.post('/reset/', userController.postReset)

###
Gets current logged in user info
###
router.get('/current/', userController.isLoggedIn)

router.get('/:email', userController.getUser)
router.put('/:email', userController.putUser)
router.delete('/:email', userController.deleteUser)



module.exports = router