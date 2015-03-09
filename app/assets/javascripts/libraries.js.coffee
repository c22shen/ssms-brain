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
$ ->
  $ppc = $('.progress-pie-chart')
  percent = parseInt($ppc.data('percent'))
  deg = 360 * percent / 100
  if percent > 50
    $ppc.addClass 'gt-50'
  $('.ppc-progress-fill').css 'transform', 'rotate(' + deg + 'deg)'
  $('.ppc-percents span').html percent + '%'
  return