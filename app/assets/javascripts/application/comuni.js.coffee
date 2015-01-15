document.addEventListener "page:fetch", ->
  $(".loading").removeClass "hidden"

document.addEventListener "page:receive", ->
  $(".loading").addClass "hidden"


jQuery ->
  $(".best_in_place").best_in_place();

  $('.bounce_on_success').bind "ajax:success", (data) ->
  	console.log data
  	$("td.provvigione", $(@).closest('tr.movimento')).html "aggiorna..."


  
