# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# 44.50249184009872
# 11.33302944445802

jQuery ->
  if $('#map-home').length
    console.log 'urra'
    map = new GMaps
      div: '#map-home'
      lat: 44.49857200306232
      lng: 11.332459900305139
    
    map.drawRoute
      origin: [44.50249184009872, 11.33302944445802]
      destination: [44.496153, 11.329235]
      travelMode: 'drive'
      strokeColor: 'blue'
      strokeOpacity: 0.6
      strokeWeight: 6
    
    map.drawRoute
      origin: [44.49927790307992, 11.327107126953138]
      destination: [44.496153, 11.329235]
      travelMode: 'drive'
      strokeColor: 'red'
      strokeOpacity: 0.6
      strokeWeight: 6

    map.drawRoute
      origin: [44.49897180459999, 11.327965433837903]
      destination: [44.496153, 11.329235]
      travelMode: 'driving'
      strokeColor: 'green'
      strokeOpacity: 0.6
      strokeWeight: 6
    
    map.addMarker
      lat: 44.496153
      lng: 11.329235
      title: "Crocevia - mercato dell'usato"
      infoWindow:
        content: "<p><strong>Crocevia - mercato dell'usato</strong></br>Via Santa Croce 11/abcdef</br>40121 Bologna</p>" 
      click: ->
        console.log 'You clicked in this marker'
      