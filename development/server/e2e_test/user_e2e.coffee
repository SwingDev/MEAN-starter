chai = require("chai")
should = chai.should()

describe "Dummy test", ->
  it "should always pass", ->
    return
  return

# describe "Google searching", ->
#   before ->
#     casper.start "http://www.google.fr/"
#     return

#   it "should retrieve 10 or more results", ->
#     casper.then ->
#       casper.getTitle().should.contain('Google')
#       casper.exists('form[action="/search"]').should.be.true
#       @fill "form[action=\"/search\"]",
#         q: "casperjs"
#       , true
#       return

#     casper.waitForUrl /q=casperjs/, ->
#       (/casperjs/).should.matchTitle
#       return

#     return

#   return
