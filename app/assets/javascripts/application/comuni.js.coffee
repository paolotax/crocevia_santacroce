document.addEventListener "page:fetch", ->
  $(".loading").show()

document.addEventListener "page:receive", ->
  $(".loading").hide()


jQuery ->
  $(".best_in_place").best_in_place();

  $('.bounce_on_success').bind "ajax:success", (data) ->
  	console.log data
  	$("td.provvigione", $(@).closest('tr.movimento')).html "aggiorna..."

  
  $(".loading").on "ajaxSend", () ->
    $(".loading").show()
  
  $(".loading").on "ajaxComplete", () ->
    $(".loading").hide()



  $('form').on 'focus', 'input[type=number]', (e) ->
    $(@).on 'mousewheel.disableScroll', (e) ->
      e.preventDefault()
  
  $('form').on 'blur', 'input[type=number]', (e) ->
    $(@).off 'mousewheel.disableScroll'