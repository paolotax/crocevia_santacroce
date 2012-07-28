class Cliente < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  
  has_many :articoli
  
  accepts_nested_attributes_for :articoli
  
  attr_accessible :cap, :citta, :codice_fiscale, :cognome, :indirizzo, :nome,
                  :numero_tessera, :partita_iva, :provincia, :ragione_sociale, 
                  :numero_documento, :data_rilascio_documento, :tipo_documento, 
                  :documento_rilasciato_da, :telefono, :email, :cellulare, :note
  
  
  
  def full_name
    [nome, cognome, ragione_sociale].join(" ")
  end
  
  def cognome_nome
    [cognome, nome].join(" ")
  end
  
end
