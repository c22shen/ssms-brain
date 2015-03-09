$ ->
  $('#location_container').highcharts
    chart:
      renderTo: 'container'
      animation: false
    title: text: ''
    yAxis: title: text: ''
    xAxis: text: ''
    plotOptions:
      scatter:
        marker: radius: 5
        tooltip:
          headerFormat: ''
          pointFormat: 'Device UID: {point.name} X: {point.x:.2f} Y: {point.y:.2f}'
      series:
        cursor: 'ns-resize'
        point: events: 
          drag: (e) ->
            # Returning false stops the drag and drops. Example:

            # if e.newY < 0
            #   @y = 0
            #   return false
            # if e.newX < 0
            #   @x = 0
            #   return false
            

            $('#drag').html 'Dragging Device: ' + this.name + ' to <b> x:' + Highcharts.numberFormat(e.newX, 2) + ' y: ' + Highcharts.numberFormat(e.newY, 2) 
            return
          drop: ->
            $('#drop').html 'Device: ' + this.name + ' was set to <b> x:' + Highcharts.numberFormat(@x, 2) + ' y: ' + Highcharts.numberFormat(@y, 2)
            $.ajax '/statuses/seat_location_update',
              type: 'GET'
              dataType: 'html'
              data:
                uid: this.name
                new_x: @x
                new_y: @y
              error: () -> alert('error')
              success: () -> 
              complete: () -> 
            return
        stickyTracking: false
      column: stacking: 'normal'
    tooltip: yDecimals: 2
    series: [
      {
        name: 'study space locations'
        type: 'scatter'
        cursor: 'pointer'
        draggableX: true
        draggableY: true
        data: $('#location_container').data('location')
      }
    ]
  return

# ---
# generated by js2coffee 2.0.1