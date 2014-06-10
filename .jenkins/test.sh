#!/bin/bash
cd $WORKSPACE
mocha --reporter tap --timeout 5000 --recursive build/server/tests > $WORKSPACE/.jenkins/reports/mocha.tap
mocha-casperjs --reporter=tap --recursive build/server/e2e_test/ > $WORKSPACE/.jenkins/reports/casper.tap
istanbul cover _mocha -- --recursive build/server --timeout 5000
