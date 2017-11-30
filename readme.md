# Async eventer [![Travis CI](https://img.shields.io/travis/nazar-pc/async-eventer/master.svg?label=Travis%20CI)](https://travis-ci.org/nazar-pc/async-eventer)
A tiny library with asynchronous Promise-based implementation of events dispatching and handling.

This library works in Node and in Browser environments (UMD) and is optimized for very small size (under 1000 bytes raw, under 500 bytes gz).

## How to install
```
npm install async-eventer
```

## How to use
Node.js:
```javascript
var Eventer = require('async-eventer')

var instance = Eventer();
// Do stuff
```
Browser:
```javascript
requirejs(['async-eventer'], function (Eventer) {
    var instance = Eventer();
    // Do stuff
})
```

## API

### Eventer.on(event: string, callback: Function) : Eventer
Register event handler.

### Eventer.once(event: string, callback: Function) : Eventer
Register one-time event handler (just `on()` + `off()` under the hood).

### Eventer.off(event: string[, callback: Function]) : Eventer
Unregister event handler.

### Eventer.fire(event: string, ...param) : Promise
Dispatch an event with arbitrary number of parameters.

`tests/index.ls` contains usage examples.

## Contribution
Feel free to create issues and send pull requests (for big changes create an issue first and link it from the PR), they are highly appreciated!

When reading LiveScript code make sure to configure 1 tab to be 4 spaces (GitHub uses 8 by default), otherwise code might be hard to read.

## License
MIT, see license.txt
