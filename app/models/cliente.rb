class Cliente < ActiveRecord::Base
  attr_accessible :cap, :citta, :codice_fiscale, :cognome, :indirizzo, :nome,
                  :numero_tessera, :partita_iva, :provincia, :ragione_sociale, 
                  :numero_documento, :scadenza_documento, :tipo_documento
  
  def full_name
    [nome, cognome, ragione_sociale].join(" ")
  end
  
end
