jQuery ->
  $(".loading").ajaxStart ->
     $(@).removeClass "hidden"
  $(".loading").ajaxStop ->
    $(@).addClass "hidden"
  
