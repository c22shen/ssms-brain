# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "click", "#search-btn", ->
  button = $(this)
  location_text  = $('#search_location').val() 
  if location_text is ''
    alert 'Fill in location field, it is empty'
  else
    $.ajax 'libraries/find_location',
      type: 'GET'
      dataType: 'json'
      data:
        location_text: location_text
      error: () -> alert('error')
      success: (data) -> 
        lat = data[0]
        lng = data[1]
        $('#library_lat').val(lat)
        $('#library_lon').val(lng)
        new_src = 'https://maps.googleapis.com/maps/api/staticmap?center=' + lat + ',' + lng + '&zoom=14&size=300x300&markers=color:blue|' + lat + ',' + lng
        $('#map_img').attr('src', new_src)


  


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

$(document).on "click", ".volume-btn", ->
  button = $(this)
  floorContainerName = button.siblings(":last").attr('id')
  floor = button.attr('data-floor')
  library = button.attr('data-library')
  $.ajax '/libraries/update_volume_chart',
      type: 'GET'
      dataType: 'html'
      data:
        floor_number: floor
        library_id: library
      error: () -> alert('error')
      success: (data) -> 
        $('#info-div').attr('data-seatsvolumearray', data)
        $('#info-div').attr('data-volumedisplayfloor', floor)
      complete: () -> 
        infoDiv = $('#info-div')
        volumeContainerName = infoDiv.attr('data-volumecontainername')
        seatsVolumeArray = infoDiv.attr('data-seatsvolumearray')
        drawVolumeChart(volumeContainerName, JSON.parse(seatsVolumeArray))
        $('#volumeNameDisplay').html('FLOOR: '+floor)
        $("html,body").animate
              scrollTop: $(".volume-map-section").offset().top
            , "slow"

$(document).on "click", "#commentSubmitBtn", ->
  button = $(this)
  libraryid = button.attr('data-libraryid')
  articleSection = button.closest('.new-article')
  recent_article_container = articleSection.next() 
  recent_article_id = articleSection.next().attr('data-articleid')
  name = articleSection.find('#commentTitleField').val()
  rating = articleSection.find('#commentRatingField').val()
  content = articleSection.find('#commentContentField').val()
  $.ajax '/libraries/save_retrieve_comments',
    type: 'GET'
    dataType: 'html'
    data:
      library_id: libraryid
      title: name
      rating: rating
      text: content
      recent_article_id: recent_article_id
    error: () -> alert('error')
    success: (data) -> 
      # hide_data = $.parseHTML(data).hide()
      recent_article_container.before data
      # hide_data.show 'slow'
    complete: () -> 
      $('#commentTitleField').val ''
      $('#commentRatingField').val ''
      $('#commentContentField').val ''


$(document).on "focus", "#commentTitleField", ->
  textfield = $(this)
  textfield.css 'border-bottom-color', '#FD7AA6 !important'
  return
$(document).ready ->
  if $('#commentRatingField').length
    $('#commentRatingField').numeric({ negative : false });
  return

$ ->
  $ppc = $('.progress-pie-chart')
  percent = parseInt($ppc.data('percent'))
  deg = 360 * percent / 100
  if percent > 50
    $ppc.addClass 'gt-50'
  $('.ppc-progress-fill').css 'transform', 'rotate(' + deg + 'deg)'
  $('.ppc-percents span').html percent + '%'
  return