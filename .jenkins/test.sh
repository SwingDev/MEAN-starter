mocha --reporter tap --timeout 5000 --recursive build/server > $WORKSPACE/.jenkins/reports/mocha.tap
istanbul cover _mocha -- --recursive build/server --timeout 5000
