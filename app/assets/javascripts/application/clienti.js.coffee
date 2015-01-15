jQuery ->

  $(".get-cf").on 'click', (e) ->

    e.preventDefault();
    
    data =
      cliente:
        cognome: $('#cliente_cognome').val()
        nome:    $('#cliente_nome').val()
        sesso:   $('#cliente_sesso').val()
        data_nascita:   $("#cliente_data_di_nascita_text").val()
        comune_nascita: $("#cliente_comune_di_nascita").val()
        
    $.post "/codice_fiscale", data, (data) ->
      $("input#cliente_codice_fiscale").val data.codice_fiscale
