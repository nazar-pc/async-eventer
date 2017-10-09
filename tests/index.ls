/**
 * @package   Async eventer
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2017, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
Eventer	= require('..')
test	= require('tape')

test('Basic usage', (t) !->
	t.plan(9)

	var result
	instance = Eventer()

	result	= 0
	instance.on('event_1', !->
		++result
	)
	instance.once('event_1', !->
		++result
	)
	<-! instance.fire('event_1').then
	t.equal(result, 2, 'on() and once() are called on fire()')

	<-! instance.fire('event_1').then
	t.equal(result, 3, 'once() was not called on second fire(), but on() still was')

	instance.off('event_1')
	<-! instance.fire('event_1').then
	t.equal(result, 3, 'off() unregistered event handler')

	result	:= []
	!function event_2_handler
		result.push(1)
	instance.on('event_2', event_2_handler)
	instance.once('event_2', !->
		result.push(2)
	)
	instance.on('event_2', !->
		result.push(3)
	)
	<-! instance.fire('event_2').then
	t.equal(result.join(', '), [1, 2, 3].join(', '), 'event handlers are called in the order they were registered')

	result	:= []
	instance.off('event_2', event_2_handler)
	<-! instance.fire('event_2').then
	t.equal(result.join(', '), [3].join(', '), 'specific event handler was unregistered')
	instance.off('event_2')

	result		:= []
	return_1	= true
	return_2	= Promise.resolve()
	return_3	= false
	return_4	= true
	instance.on('event_3', ->
		result.push(1)
		return_1
	)
	instance.on('event_3', ->
		result.push(2)
		return_2
	)
	instance.on('event_3', ->
		result.push(3)
		return_3
	)
	instance.on('event_3', ->
		result.push(4)
		return_4
	)
	<-! instance.fire('event_3').catch
	t.equal(result.join(', '), [1, 2, 3].join(', '), 'false prevents further event handlers execution')

	result		:= []
	return_2	:= ''
	return_3	:= Promise.reject()
	<-! instance.fire('event_3').catch
	t.equal(result.join(', '), [1, 2, 3].join(', '), "rejected Promise also prevents further event handlers execution")
	instance.off('event_3')

	instance.on('event_4', (data_1, data_2) !->
		data_1.x = 'x'
		data_2.y = 'y'
	)
	data_1 = {}
	data_2 = {}
	<-! instance.fire('event_4', data_1, data_2).then
	t.equal(data_1.x, 'x', 'First argument is fine')
	t.equal(data_2.y, 'y', 'Second argument is fine')
	instance.off('event_4')
)
