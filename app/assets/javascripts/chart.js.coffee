jQuery ->
  if $('#info-div').length>0

    infoDiv = $('#info-div')
    activateChart = infoDiv.data('activatechart')
    splineContainerName = infoDiv.data('splinecontainername')
    d3ContainerName = infoDiv.data('d3containername')
    floorContainerName = infoDiv.data('floorcontainername')
    volumeContainerName =  infoDiv.data('volumecontainername')
    seats3dArray = infoDiv.data('seats3darray')
    seatsFloorArray = infoDiv.data('seatsfloorarray')
    seatsVolumeArray = infoDiv.data('seatsvolumearray')
    # console.log seatsVolumeArray
    freeSeatCount = infoDiv.data('freeseatcount')
    plot3dZMax = infoDiv.data('plot3dzmax')
    plot3dYMax = infoDiv.data('plot3dymax')
    lat = infoDiv.data('lat')
    lon = infoDiv.data('lon')
    libraryVolumeArray = infoDiv.data('libraryvolumearray')
    if activateChart
        drawSplineChart(splineContainerName, freeSeatCount)
        draw3DScatterGraph(d3ContainerName, seats3dArray, plot3dZMax, plot3dYMax)
        drawFloorChart(floorContainerName, seatsFloorArray)
        drawVolumeChart(volumeContainerName, seatsVolumeArray)
    google.maps.event.addDomListener window, 'load', initialize(lat, lon)
  if $('#info1-div').length>0
    info1Div = $('#info1-div')
    barContainerName = info1Div.data('barcontainername')
    libraryNamesArray = info1Div.data('librarynamesarray')
    libraryFreeInfoArray = info1Div.data('libraryfreeinfoarray')
    libraryBusyInfoArray = info1Div.data('librarybusyinfoarray')
    drawBarGraph(barContainerName, libraryNamesArray, libraryFreeInfoArray, libraryBusyInfoArray)
    nearLibraryLocations = info1Div.data('nearlibraries') 
    google.maps.event.addDomListener window, 'load', initialize_map(nearLibraryLocations)