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

## User API
Differences from express-user-couchdb:

* No email verify.
* No groups.
* Single user attribute `isAdmin` giving user superpowers.

### Brief summary of API methods
Go to `routes/user.coffee` and look at the comments. You will probably have to change stuff in passwor reset controller, to match your domain, port, templates and frontend url schema.

## Configuring
All configs should be imported from from `config/config` file. 
The file imports config from other files in following order (config in later files will overwrite config from previous files):
* `config/env/all` - store your general config there
* `config/env/[dev|production|staging|test]` - store config specific for environment there. The environment is chosen based on value of `NODE_EVN` process env variable. 
* `config/secrets` - this file should not be tracking on git and you should keep all password and secret API keys there. 