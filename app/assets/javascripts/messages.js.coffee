# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

source = new EventSource('/messages/events')
source.addEventListener 'message', (e) ->

	uid = $.parseJSON(e.data).uid
	status = $.parseJSON(e.data).status
	x = $.parseJSON(e.data).x
	y = $.parseJSON(e.data).y
	free_seat_percent = $.parseJSON(e.data).percent
	free_seat_count = $.parseJSON(e.data).free_seat_count
	busy_seat_count = $.parseJSON(e.data).busy_seat_count
	away_seat_count = $.parseJSON(e.data).away_seat_count
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
	if select == true
		old_pt.select()
		setTimeout (->
		  old_pt.select false
		  return
		), 3000

	chart1 = $('#container1').highcharts()
	x_time = (new Date()).getTime()

	new_pt1 = [x_time, free_seat_percent]
	chart1.series[0].addPoint(new_pt1,true,true)

	$('#free_seat_count_label').text free_seat_count
	$('#busy_seat_count_label').text busy_seat_count
	$('#away_seat_count_label').text away_seat_count
	$('.progress-pie-chart').data 'percent', free_seat_percent

	$ppc = $('.progress-pie-chart')
	percent = free_seat_percent
	deg = 360 * percent / 100
	if percent > 50
		$ppc.addClass 'gt-50'
	$('.ppc-progress-fill').css 'transform', 'rotate(' + deg + 'deg)'
	$('.ppc-percents span').html percent + '%'

	if percent > 20
		$('.status-message').html("   <i class='fa fa-smile-o' style='color:white; font-size:30px'></i>
      - Library is fairly empty right now, studying at the library seems like a great idea.")
	else
		$('.status-message').html(" <i class='fa fa-frown-o' style='color:white; font-size:30px'></i>
        - Library is pretty busy right now, maybe it is better to study at home today.")




