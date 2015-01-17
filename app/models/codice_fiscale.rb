class CodiceFiscale
  
  attr_reader :codice_fiscale
  
  def initialize(cliente)
    
    request_body = {
      "Cognome"       => cliente[:cognome],
      "Nome"          => cliente[:nome],
      "Sesso"         => cliente[:sesso],
      "DataNascita"   => cliente[:data_nascita],
      "ComuneNascita" => cliente[:comune_nascita]
    }
    
    client = Savon.client(wsdl: "http://webservices.dotnethell.it//codicefiscale.asmx?wsdl")

    response = client.call  :calcola_codice_fiscale, message: request_body
    
    if response.success?
      data = response.to_array(:calcola_codice_fiscale_response, :calcola_codice_fiscale_result).first
      if data
        @codice_fiscale = data
      end
    end
  end  
end  