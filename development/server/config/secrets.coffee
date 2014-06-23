
#
#IMPORTANT * IMPORTANT * IMPORTANT * IMPORTANT * IMPORTANT * IMPORTANT *
#
#You should never commit this file to a public repository on GitHub!
#All public code on GitHub can be searched, that means anyone can see your
#uploaded secrets.js file.
#
#I did it for your convenience using "throw away" credentials so that
#all features could work out of the box.
#
#Untrack secrets.coffee before pushing your code to public GitHub repository:
#
#git rm --cached config/secrets.coffee
#
#If you have already commited this file to GitHub with your keys, then
#refer to https://help.github.com/articles/remove-sensitive-data
#
module.exports =
  sessionSecret: process.env.SESSION_SECRET or "Your Session Secret goes here"
  mailgun:
    user: process.env.MAILGUN_USER or "MAILGUN_USER"
    password: process.env.MAILGUN_PASSWORD or "MAILGUN_PASSWORD"
