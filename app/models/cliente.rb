require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Cliente < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  
  has_many :articoli, dependent: :destroy
  
  has_many :articoli_in_giacenza, class_name: "Articolo",
                                  conditions: "(articoli.quantita > articoli.movimenti_count)"
  
  has_many :movimenti, through: :articoli 
  
  has_many :vendite, through: :articoli, 
                     source: :movimenti,
                     conditions: { tipo: "vendita" }
                     
  has_many :rese, through: :articoli, 
                  source: :movimenti,
                  conditions: { tipo: "resa"}
  
  before_save :update_index
                      
  accepts_nested_attributes_for :articoli
  
  attr_accessible :cap, :citta, :codice_fiscale, :cognome, :indirizzo, :nome,
                  :numero_tessera, :partita_iva, :provincia, :ragione_sociale, 
                  :numero_documento, :data_rilascio_documento_text, :tipo_documento, 
                  :documento_rilasciato_da, :telefono, :email, :cellulare, :note,
                  :data_di_nascita_text, :comune_di_nascita, :sesso, :index

  attr_writer :data_rilascio_documento_text, :data_di_nascita_text
  
  validates :nome,              presence: true
  validates :tipo_documento,    presence: true
  validates :numero_documento,  presence: true 
  validates :comune_di_nascita, presence: true 
  validates :sesso,             presence: true, :inclusion => { :in => %w(m f) }
  
  validates :documento_rilasciato_da,      presence: true
  validates :data_rilascio_documento_text, presence: true
  validates :data_di_nascita_text,         presence: true 
  
  validate    :check_data_rilascio_documento_text, :check_data_di_nascita_text
  before_save :save_data_rilascio_documento_text,  :save_data_di_nascita_text  

  def full_name
    [nome, cognome, ragione_sociale].join(" ")
  end
  
  def to_s
    full_name
  end
  
  def to_barby
    barcode_value = self.id.to_s
    barcode = Barby::Code39.new(barcode_value)
    full_path = "public/barcodes/tessera_#{barcode_value}.png"
    File.open(full_path, 'w') { |f| f.write barcode.to_png(:margin => 0, :xdim => 2, :height => 30) }
  end
  
  def cognome_nome
    [cognome, nome].join(" ")
  end
  
  def maschio?
    self.sesso == "m"
  end
  
  def has_articoli_attivi?
    !self.articoli.attivo.all.empty?
  end
  
  def has_articoli_registrati?
    !self.articoli.registrato.all.empty?
  end
  
  def data_rilascio_documento_text
    @data_rilascio_documento_text || data_rilascio_documento.try(:strftime, "%d-%m-%Y")
  end

  def data_di_nascita_text
    @data_di_nascita_text || data_di_nascita.try(:strftime, "%d-%m-%Y")
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

    def save_data_di_nascita_text
      self.data_di_nascita = Date.parse(@data_di_nascita_text) if @data_di_nascita_text.present?
    end

    def check_data_di_nascita_text
      if @data_di_nascita_text.present? && Date.parse(@data_di_nascita_text).nil?
        errors.add :data_di_nascita_text, "cannot be parsed"
      end
    rescue ArgumentError
      errors.add :data_di_nascita_text, "data non valida"
    end
    
    

    def update_index
      self.index = "#{id} #{nome} #{cognome} #{ragione_sociale}"
    end

end
