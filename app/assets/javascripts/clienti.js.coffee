# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  
  $(".get-cf a").live 'click', (e) ->
    
    e.preventDefault();
    
    url = $(@).attr('href');
    console.log url
    $.getJSON url, (data) ->
      
      $("input#cliente_codice_fiscale").val data.codice_fiscale
        
        
    
    