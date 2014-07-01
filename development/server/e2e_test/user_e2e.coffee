chai = require("chai")
should = chai.should()

casper_chai = require 'casper-chai'
chai.use casper_chai

describe "AuthController", ->
  before ->
    return

  it 'should show "Sign in" form view', (done) ->
    casper
      .start 'http://localhost:3000/#/signin', (response) ->
        console.log response
        return
      .then () ->
        return 'form[name="signInForm"]'.should.be.inDOM.and.visible
    return

  it 'should show alert error', (done) ->
    casper
      .then () ->
        @click 'form[name="signInForm"] button[type="submit"]'
        '/html/body/div/div/div/span'.should.be.inDOM.and.visible
        return
    return

  # it "should show 'Sign up' form view", (done) ->
  #   casper
  #     .open '/#/signup'
  #     .then () ->
  #       'form[name="signUpForm"]'.should.be.inDOM
  #       'form[name="signUpForm"]'.should.be.visible
  #
  #       return
  #   return

  return
