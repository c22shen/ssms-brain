# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

source = new EventSource('/messages/events')
source.addEventListener 'message', (e) ->

	uid = $.parseJSON(e.data).uid
	status = $.parseJSON(e.data).status
	x = $.parseJSON(e.data).x
	y = $.parseJSON(e.data).y
	percent = $.parseJSON(e.data).percent
	chart = $('#container').highcharts()
	old_pt = chart.get(uid)
	old_pt.remove()
	new_pt = {
    'name': uid,
    'id': uid,
    color: status,
    'y': y,
    'x': x
	}
	chart.series[0].addPoint(new_pt)
	chart1 = $('#container1').highcharts()
	x_time = (new Date()).getTime()

	new_pt1 = [x_time, percent]
	chart1.series[0].addPoint(new_pt1,true,true)