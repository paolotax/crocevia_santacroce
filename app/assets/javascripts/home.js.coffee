# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if $('#map-home').length
    console.log 'urra'
    map = new GMaps
      div: '#map-home'
      lat: 44.496153
      lng: 11.329235
    
    map.addMarker
      lat: 44.496153
      lng: 11.329235
      title: "Crocevia - mercato dell'usato"
      infoWindow:
        content: "<p><strong>Crocevia - mercato dell'usato</strong></br>Via Santa Croce 11/abcdef</br>40121 Bologna</p>" 
      click: ->
        console.log 'You clicked in this marker'
      