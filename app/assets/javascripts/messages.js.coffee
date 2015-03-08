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
	select = $.parseJSON(e.data).select
	chart = $('#container').highcharts()
	old_pt = chart.get(uid)
	old_pt.update marker:
	  fillColor: status
	  states:
	    hover:
	      fillColor: status
	      lineColor: status
	    select:
	      fillColor: status
	      lineColor: status    
	      lineWidth: 10
	# old_pt.setState('hover')
	if select == true
	  old_pt.select()

	chart1 = $('#container1').highcharts()
	x_time = (new Date()).getTime()

	new_pt1 = [x_time, percent]
	chart1.series[0].addPoint(new_pt1,true,true)
