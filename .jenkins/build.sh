#!/bin/bash

# cd $WORKSPACE
bower install
npm install
npm install -g mocha
npm install -g istanbul
npm install -g brunch
npm install -g gulp

mkdir -p .data/db
mkdir -p build
brunch build
gulp compile