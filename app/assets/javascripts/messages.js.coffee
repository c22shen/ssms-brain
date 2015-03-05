# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

source = new EventSource('/messages/events')
source.addEventListener 'message', (e) ->

	uid = $.parseJSON(e.data).uid
	status = $.parseJSON(e.data).status
	$('.testing').text("#{status}")