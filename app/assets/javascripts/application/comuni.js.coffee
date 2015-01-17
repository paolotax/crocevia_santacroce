document.addEventListener "page:fetch", ->
  $("#loading").show()

document.addEventListener "page:receive", ->
  $("#loading").hide()

$(document).on "ajaxSend", () ->
  console.log "GINO"
  $("#loading").show()

$(document).on "ajaxComplete", () ->
  $("#loading").hide()

jQuery ->

  $(window).on 'popstate', (event) ->
    $("#loading").hide()
  
  $(".best_in_place").best_in_place();

  $('.bounce_on_success').bind "ajax:success", (data) ->
  	console.log data
  	$("td.provvigione", $(@).closest('tr.movimento')).html "aggiorna..."

  




  $('form').on 'focus', 'input[type=number]', (e) ->
    $(@).on 'mousewheel.disableScroll', (e) ->
      e.preventDefault()
  
  $('form').on 'blur', 'input[type=number]', (e) ->
    $(@).off 'mousewheel.disableScroll'