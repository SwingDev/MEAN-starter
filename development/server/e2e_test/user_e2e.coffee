chai = require("chai")
should = chai.should()

casper_chai = require 'casper-chai'
chai.use casper_chai

describe "AuthController", ->

  it 'should SHOW "Sign in" form view', () ->
    casper
      .start 'http://localhost:3000/#/signin', () ->
        return 'form[name="signInForm"]'.should.be.inDOM.and.visible
    return

  it 'should SHOW alert error', () ->
    casper
      .then () ->
        @click 'form[name="signInForm"] button[type="submit"]'
        return '.alert > div > span'.should.be.inDOM.and.visible
    return

  it 'should SHOW e-mail validation error message', () ->
    casper
      .then () ->
        @fill 'form[name="signInForm"]',
          'email': 'example'
        , false
        return 'form[name="signInForm"] > div.form-group.has-error > span:nth-child(3)'.should.be.visible
    return

  it 'should HIDE e-mail validation error message', () ->
    casper
      .then () ->
        @fill 'form[name="signInForm"]',
          'email': 'example@example.com'
        , false
        return 'form[name="signInForm"] > div.form-group.has-error > span:nth-child(3)'.should.not.be.visible
    return

  it 'should SHOW user verification alert', () ->
    casper
      .then () ->
        @fill 'form[name="signInForm"]',
          'email': 'example@example.com'
          'password': 'example-password'
        , true
        return '.alert > div > span'.should.be.inDOM.and.visible
    return

  it 'should SHOW "Sign up" form view', () ->
    casper
      .thenOpen 'http://localhost:3000/#/signup', () ->
        return 'form[name="signUpForm"]'.should.be.inDOM.and.visible
    return

  it 'should SHOW e-mail validation error message', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'email': 'example'
        , false
        return 'form[name="signUpForm"] > div.form-group.has-error > span:nth-child(3)'.should.be.visible
    return

  it 'should HIDE e-mail validation error message', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'email': 'example@example.com'
        , false
        return 'form[name="signUpForm"] > div.form-group.has-error > span:nth-child(3)'.should.not.be.visible
    return

  it 'should SHOW form main error alert', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'email': ''
        , true
        return '.alert > div > span'.should.be.inDOM.and.visible
    return

  it 'should SHOW password confirmation match error message', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'password': 'example'
          'password_confirmation': 'exampl'
        , true
        return
      .then () ->
        return 'form[name="signUpForm"] > div.form-group.has-error > span:nth-child(2)'.should.be.visible
    return

  it 'should HIDE password confirmation match error message', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'email': 'example@example.com'
          'password': 'example'
          'password_confirmation': 'example'
        , true
        return 'form[name="signUpForm"] > div.form-group.has-error > span:nth-child(3)'.should.not.be.visible
    return

  it 'should SHOW password validation error message', () ->
    casper
      .then () ->
        @fill 'form[name="signUpForm"]',
          'email': 'example@example.com'
          'password': 'exa'
          'password_confirmation': 'exa'
        , true
        return
      .waitUntilVisible 'form[name="signUpForm"] > div.form-group.has-error > span.help-block'
      .then () ->
        'form[name="signUpForm"] > div.form-group.has-error > span.help-block'.should.be.inDOM.and.visible
        return
    return

  return
