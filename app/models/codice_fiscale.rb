class CodiceFiscale
  
  attr_reader :codice_fiscale
  
  def initialize(cliente)
    
    request_body = {
      "Cognome" => cliente.cognome,
      "Nome" => cliente.nome,
      "Sesso" => cliente.sesso,
      "DataNascita" => cliente.data_di_nascita_text,
      "ComuneNascita" => cliente.comune_di_nascita
    }
    
    client = Savon::Client.new("http://webservices.dotnethell.it//codicefiscale.asmx?wsdl")
    response = client.request :web, :calcola_codice_fiscale, :body => request_body
    
    if response.success?
      data = response.to_array(:calcola_codice_fiscale_response, :calcola_codice_fiscale_result).first
      if data
        @codice_fiscale = data
      end
    end
  end  
end  