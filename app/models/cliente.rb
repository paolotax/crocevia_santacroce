class Cliente < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  
  has_many :articoli
  
  accepts_nested_attributes_for :articoli
  
  attr_accessible :cap, :citta, :codice_fiscale, :cognome, :indirizzo, :nome,
                  :numero_tessera, :partita_iva, :provincia, :ragione_sociale, 
                  :numero_documento, :data_rilascio_documento_text, :tipo_documento, 
                  :documento_rilasciato_da, :telefono, :email, :cellulare, :note

  attr_writer :data_rilascio_documento_text
  validate :check_data_rilascio_documento_text
  before_save :save_data_rilascio_documento_text  

  def full_name
    [nome, cognome, ragione_sociale].join(" ")
  end
  
  def cognome_nome
    [cognome, nome].join(" ")
  end
  

  def data_rilascio_documento_text
    @data_rilascio_documento_text || data_rilascio_documento.try(:strftime, "%d-%m-%Y")
  end

  private
    def save_data_rilascio_documento_text
      self.data_rilascio_documento = Date.parse(@data_rilascio_documento_text) if @data_rilascio_documento_text.present?
    end

    def check_data_rilascio_documento_text
      if @data_rilascio_documento_text.present? && Date.parse(@data_rilascio_documento_text).nil?
        errors.add :data_rilascio_documento_text, "cannot be parsed"
      end
    rescue ArgumentError
      errors.add :data_rilascio_documento_text, "data non valida"
    end

end
