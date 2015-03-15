# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
shadeColor2 = (color, percent) ->
  f = parseInt(color.slice(1), 16)
  t = if percent < 0 then 0 else 255
  p = if percent < 0 then percent * -1 else percent
  R = f >> 16
  G = f >> 8 & 0x00FF
  B = f & 0x0000FF
  '#' + (0x1000000 + (Math.round((t - R) * p) + R) * 0x10000 + (Math.round((t - G) * p) + G) * 0x100 + Math.round((t - B) * p) + B).toString(16).slice(1)

source = new EventSource('/messages/events')
source.addEventListener 'message', (e) ->
	data_source = $.parseJSON(e.data)
	id = data_source.id
	status = data_source.status
	x = data_source.x
	y = data_source.y
	z = data_source.z
	free_seat_percent = data_source.free_seat_percentage
	free_seat_count = data_source.free_seat_count
	busy_seat_count = data_source.busy_seat_count

	free_seat_data_array = data_source.free_seat_data_array
	busy_seat_data_array = data_source.busy_seat_data_array

	splineChartContainerName = data_source.splineChartContainerName
	d3ChartContainerName = data_source.d3ChartContainerName
	barChartContainerName = data_source.barChartContainerName
	floorChartContainerName = data_source.floorChartContainerName

	freeSeatCountLabelName = data_source.freeSeatCountLabelName
	busySeatCountLabelName = data_source.busySeatCountLabelName
	freeSeatPercentChartName = data_source.freeSeatPercentChartName
	occupancyMsgContainerName = data_source.occupancyMsgContainerName
	
	displayFloor = $('#info-div').data('displayfloor')
	if z == displayFloor
		floorChart = $(floorChartContainerName).highcharts()
		old_pt = floorChart.get(id)
		old_pt.update marker:
		  fillColor: status
		  states:
		    hover:
		      fillColor: status
		      lineColor: status
		    select:
		      fillColor: shadeColor2(status,0.3)
		      lineColor: shadeColor2(status,0.3)
		      lineWidth: 5
		old_pt.select()
	
	
	d3Chart = $(d3ChartContainerName).highcharts()
	old_pt = d3Chart.get(id)
	old_pt.update marker:
	  fillColor: status
	  states:
	    hover:
	      fillColor: status
	      lineColor: status
	    select:
	      fillColor: shadeColor2(status,0.3)
	      lineColor: shadeColor2(status,0.3)
	      lineWidth: 1
	old_pt.select()

	splineChart = $(splineChartContainerName).highcharts()
	x_time = (new Date()).getTime() #current time
	new_pt = [x_time, free_seat_count]
	splineChart.series[0].addPoint(new_pt,true,true)

	$(freeSeatCountLabelName).text free_seat_count
	$(busySeatCountLabelName).text busy_seat_count
	$(freeSeatPercentChartName).data 'percent', free_seat_percent

	$ppc = $('.progress-pie-chart')
	percent = free_seat_percent
	deg = 360 * percent / 100
	if percent > 50
		$ppc.addClass 'gt-50'
	$('.ppc-progress-fill').css 'transform', 'rotate(' + deg + 'deg)'
	$('.ppc-percents span').html percent + '%'

	if percent > 20
		$(occupancyMsgContainerName).html("   <i class='fa fa-smile-o' style='color:white; font-size:30px'></i>
      - Library is fairly empty right now, studying at the library seems like a great idea.")
	else
		$(occupancyMsgContainerName).html(" <i class='fa fa-frown-o' style='color:white; font-size:30px'></i>
        - Library is pretty busy right now, maybe it is better to study at home today.")
	
	barChart = $(barChartContainerName).highcharts()
	barChart.series[1].setData(free_seat_data_array)
	barChart.series[0].setData(busy_seat_data_array)



