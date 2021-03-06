// Generated by LiveScript 1.5.0
/**
 * @package Async eventer
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
(function(){
  var callbacks_map, callbacks_aliases;
  callbacks_map = new WeakMap;
  callbacks_aliases = new WeakMap;
  /**
   * @constructor
   */
  function Eventer(){
    if (!(this instanceof Eventer)) {
      return new Eventer;
    }
    callbacks_map.set(this, {});
  }
  Eventer.prototype = {
    /**
     * @param {string}		event
     * @param {!Function}	callback
     *
     * @return {!Eventer}
     */
    'on': function(event, callback){
      var ref$;
      if (event && callback) {
        ((ref$ = callbacks_map.get(this))[event] || (ref$[event] = [])).push(callback);
      }
      return this;
    }
    /**
     * @param {string}		event
     * @param {!Function}	[callback]
     *
     * @return {!Eventer}
     */,
    'off': function(event, callback){
      var callbacks, real_callback, index;
      callbacks = callbacks_map.get(this)[event];
      if (callbacks) {
        if (callback) {
          real_callback = callbacks_aliases.get(callback) || callback;
          index = callbacks.indexOf(real_callback);
          if (index !== -1) {
            callbacks.splice(index, 1);
          }
        } else {
          delete callbacks_map.get(this)[event];
        }
      }
      return this;
    }
    /**
     * @param {string}		event
     * @param {!Function}	callback
     *
     * @return {!Eventer}
     */,
    'once': function(event, callback){
      var callback_, this$ = this;
      if (event && callback) {
        callback_ = function(){
          if (callback_.used) {
            return;
          }
          callback_.used = true;
          this$['off'](event, callback_);
          return callback.apply(null, arguments);
        };
        callbacks_aliases.set(callback, callback_);
        this['on'](event, callback_);
      }
      return this;
    }
    /**
     * @param {string}	event
     * @param {...*}	param
     *
     * @return {!Promise}
     */,
    'fire': function(event, param){
      var result_promise, params;
      result_promise = Promise.resolve();
      params = arguments;
      (callbacks_map.get(this)[event] || []).forEach(function(callback){
        result_promise = result_promise.then(function(){
          var result;
          result = callback.call.apply(callback, params);
          if (result === false) {
            return Promise.reject();
          } else {
            return result;
          }
        });
      });
      result_promise['catch'](function(error){
        if (error instanceof Error) {
          console.error(error);
        }
      });
      return result_promise;
    }
  };
  if (typeof define === 'function' && define['amd']) {
    define(function(){
      return Eventer;
    });
  } else if (typeof exports === 'object') {
    module.exports = Eventer;
  } else {
    this['async_eventer'] = Eventer;
  }
}).call(this);
