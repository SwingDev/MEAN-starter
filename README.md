MEAN-starter
============

## Installing
Make sure you have node, npm and mongodb installed.
First go `npm install` and `bower install`

Take a look at `./.jenkins/build.sh` to see what else is needed. 

## Starting MongoDB
Make sure you have `.data/db` directory present, then go `npm run mongo`.

## Running
We use `node-dev` to run server, it will restart your express server every time files change. Run server using `npm start` command. 

We use brunch to build front-end stuff (`brunch watch`).
We use gulp to compile backend coffee (`gulp watch`)

## Testing
Run `npm test`