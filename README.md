MEAN-starter
============

![jelly](https://www.evernote.com/shard/s16/sh/35bf1b4e-c351-4a98-a64d-c0618e8e2b43/6b0929e02f255aaf815acefecc653e3e/deep/0/north-america-lions-mane-jellyfish-625x450.jpg-625-450-pixels.png)


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

## Debugging
Run `npm run debug`

OSX MongoDB browser: [Robomongo](http://robomongo.org)

Ng-inspector for your browser [ng-inspector](http://ng-inspector.org)

## Testing
Run `npm test`

Run `npm run e2e_test`
