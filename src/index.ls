/**
 * @package Async eventer
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
/**
 * @constructor
 */
!function Eventer
	if !(@ instanceof Eventer)
		return new Eventer
	@_callbacks	= {}

Eventer:: =
	/**
	 * @param {string}		event
	 * @param {!Function}	callback
	 *
	 * @return {!Eventer}
	 */
	'on' : (event, callback) ->
		if event && callback
			@_callbacks[][event].push(callback)
		@
	/**
	 * @param {string}		event
	 * @param {!Function}	[callback]
	 *
	 * @return {!Eventer}
	 */
	'off' : (event, callback) ->
		callbacks	= @_callbacks[event]
		if callbacks
			callbacks.splice(callbacks.indexOf(callback), if callback then 1 else callbacks.length)
		@
	/**
	 * @param {string}		event
	 * @param {!Function}	callback
	 *
	 * @return {!Eventer}
	 */
	'once' : (event, callback) ->
		if event && callback
			callback_ = ~>
				if callback_.used
					return
				callback_.used	= true
				@'off'(event, callback_)
				callback(...&)
			@'on'(event, callback_)
		@
	/**
	 * @param {string}	event
	 * @param {...*}	param
	 *
	 * @return {!Promise}
	 */
	'fire' : (event, param) ->
		result_promise	= Promise.resolve()
		params			= &
		(@_callbacks[event] || []).forEach (callback) !->
			result_promise	:= result_promise.then ->
				result	= callback.call(...params)
				if result == false
					Promise.reject()
				else
					result
		result_promise.catch (error) !->
			if error instanceof Error
				console.error(error)
		result_promise

if typeof define == 'function' && define['amd']
	# AMD
	define(-> Eventer)
else if typeof exports == 'object'
	# CommonJS
	module.exports = Eventer
else
	# Browser globals
	@'async_eventer' = Eventer
