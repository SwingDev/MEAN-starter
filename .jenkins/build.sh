#!/bin/bash

npm config set prefix /Users/jenkins/.npm

cd $WORKSPACE
bower install
npm install
npm install -g mocha
npm install -g istanbul
npm install -g brunch
npm install -g gulp
npm install -g mocha-casperjs
npm install -g coffeelint

mkdir -p .data/db
mkdir -p build
brunch build
gulp compile
