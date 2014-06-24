#!/bin/bash
npm config set prefix /Users/jenkins/.npm
export PATH=$PATH:/Users/jenkins/.npm/bin
cd $WORKSPACE
mocha --reporter tap --timeout 10000 --recursive build/server/test > $WORKSPACE/.jenkins/reports/mocha.tap
mocha-casperjs --reporter=tap --recursive build/server/e2e_test/ > $WORKSPACE/.jenkins/reports/casper.tap
istanbul cover _mocha -- --recursive build/server --timeout 5000
