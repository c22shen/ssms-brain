# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click", ".mode-btn", ->
  button = $(this)
  if button.hasClass('btn-success')
    curr_style = 'success'
  else
    curr_style = 'default'	
  $.ajax '/statuses/mode_update',
    type: 'GET'
    dataType: 'html'
    error: () -> alert('error')
    success: () -> 
      if curr_style is 'default' 	
      	button.removeClass('btn-default').addClass('btn-success')
      	button.text('MAPPING')
      else
        button.removeClass('btn-success').addClass('btn-default')
    	button.text('MONITOR')
    complete: () -> 

$(document).on "click", ".option-btn", ->
  button = $(this)
  if button.hasClass('btn-success')
    curr_style = 'success'
  else
    curr_style = 'default'  
  $.ajax '/statuses/option_update',
    type: 'GET'
    dataType: 'html'
    error: () -> alert('error')
    success: () -> 
      if curr_style is 'default'  
        button.removeClass('btn-default').addClass('btn-success')
        button.text('LIVE')
      else
        button.removeClass('btn-success').addClass('btn-default')
        button.text('SIMULATION')
    complete: () -> 



$(document).on "click", ".floor-btn", ->
  button = $(this)
  floor = button.attr('data-floor')
  library = button.attr('data-library')
  $.ajax '/libraries/update_floor_chart',
      type: 'GET'
      dataType: 'html'
      data:
        floor_number: floor
        library_id: library
      error: () -> alert('error')
      success: (data) -> 
        $('#info-div').attr('data-seatsfloorarray', data)
        $('#info-div').attr('data-displayfloor', floor)
      complete: () -> 
        infoDiv = $('#info-div')
        floorContainerName = infoDiv.attr('data-floorcontainername')
        seatsFloorArray = infoDiv.attr('data-seatsfloorarray')
        drawFloorChart(floorContainerName, JSON.parse(seatsFloorArray))
        $('#floorNameDisplay').html('FLOOR: '+floor)
        $("html,body").animate
              scrollTop: $(".library-map-section1").offset().top
            , "slow"

        

  


$ ->
  $ppc = $('.progress-pie-chart')
  percent = parseInt($ppc.data('percent'))
  deg = 360 * percent / 100
  if percent > 50
    $ppc.addClass 'gt-50'
  $('.ppc-progress-fill').css 'transform', 'rotate(' + deg + 'deg)'
  $('.ppc-percents span').html percent + '%'
  return