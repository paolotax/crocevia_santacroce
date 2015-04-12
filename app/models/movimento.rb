# encoding: utf-8
class Movimento < ActiveRecord::Base
  
  
  belongs_to :articolo, counter_cache: true
  belongs_to :user
  belongs_to :documento
  belongs_to :rimborso, class_name: 'Documento'

  has_one :cliente, through: :articolo
  
  attr_accessible :prezzo, :quantita, :tipo, :articolo_id, :rimborso_id, :user

  delegate :data_carico, :data_scadenza, :data_patate, :nome, :provvigione, to: :articolo, allow_nil: true, :prefix => true
  
  delegate :data, :tipo, to: :documento, allow_nil: true, prefix: true

  
  validate :validate_articolo, on: :create
  def validate_articolo
    if Articolo.find_by_id(articolo_id)
      errors.add(:articolo, "Articolo esaurito!") if self.articolo.disponibile? == false
    else
      errors.add(:articolo, "Codice non trovato!")
    end
  end
  

  before_save   :set_prezzo
  
  after_save     :update_documento
  
  before_destroy :decrement_documento


  %w(vendita resa).each do |tipo|
    scope "#{tipo}", where('movimenti.tipo = ?', "#{tipo}")

    define_method "#{tipo}?" do
      self.tipo == tipo
    end
  end

  scope :non_eli,       joins(:articolo).where("articoli.eli is null or articoli.eli = ?", false)
  
  scope :attivo,        where('movimenti.documento_id is null')
  scope :registrato,    where('movimenti.documento_id is not null')
  scope :da_rimborsare, vendita.where("movimenti.rimborso_id is null")
  scope :rimborsato,    vendita.where("movimenti.rimborso_id is not null")  
  
  #scope :rimborsabile,  da_rimborsare.joins(:documento).where("documenti.data < ?", Time.zone.now.beginning_of_month.to_date )
  
  scope :rimborsabile,  -> { da_rimborsare.joins(:documento).where("documenti.data < ?", Time.zone.now.beginning_of_month.to_date ) }
  

  scope :mese_in_corso, -> { joins(:documento).where("documenti.data >= ?", Time.zone.now.beginning_of_month.to_date) }

  scope :mese_scorso, -> { joins(:documento).where("documenti.data >= ? AND documenti.data <= ? ", 
                                              (Time.zone.now - 1.month).beginning_of_month,
                                              (Time.zone.now - 1.month).end_of_month
                                             ) }
  
  scope :mesi_passati, -> { joins(:documento).where("documenti.data >= ? AND documenti.data <= ? ", 
                                                Time.now.beginning_of_year,
                                                (Time.zone.now - 2.month).end_of_month
                                              ) }

  
  def eli?
    patate?
  end

  
  def da_registrare?
    documento.nil?
  end
  
  
  def rimborsato?
    vendita? && !rimborso_id.nil?
  end
  
  
  def da_rimborsare?
    vendita? && !eli? && rimborso_id.nil? && !documento.nil? && documento.data < Time.now.beginning_of_month.to_date
  end

  
  def attivo?
    documento.nil?
  end


  def mandante
    cliente
  end




  def data_uscita
    try(:documento).try(:data) || created_at.to_date
  end


  def giorni_di_giacenza
    (data_uscita - articolo_data_carico).to_i
  end
   

  def patate?
    data_uscita > articolo_data_patate
  end
  

  def scaduto?
    data_uscita > articolo_data_scadenza && data_uscita < articolo_data_patate
  end
    

  def importo
    quantita * prezzo
  end
  

  def importo_cliente
    quantita * prezzo
  end
  

  def importo_provvigione
    if patate?
      0.0
    else
      prezzo / 100 * articolo_provvigione
    end
  end


  def importo_eli
    if patate?
      prezzo
    else
      0.0
    end
  end
  

  def ricavo
    prezzo - importo_provvigione
  end


  def format_prezzo
    "€ #{prezzo}"
  end  


  def self.filtra(params)
    movimenti = scoped
    movimenti = movimenti.where("documenti.data = ?", params[:del]) if params[:del].present?
    movimenti = movimenti.vendita if params[:tipo].present?  && params[:tipo] == 'vendita'
    movimenti = movimenti.where("documenti.data = ?", Date.new( params[:year].to_i, params[:month].to_i, params[:day].to_i)) if params[:day].present?
    movimenti
  end


  private

    
    def set_prezzo
      if prezzo.blank?
        self.prezzo = articolo.prezzo_vendita
        self.quantita = 1
      end 
    end
    
    
    def update_documento
      return true unless prezzo_changed? || documento_id_changed? || rimborso_id_changed?
      unless documento.nil?
        if prezzo_changed?
          Documento.update_counters documento.id, 
            :importo   => prezzo - (prezzo_was || 0.0)
        elsif documento_id_changed?
          Documento.update_counters documento.id, 
            :importo   => prezzo
        elsif rimborso_id_changed?
          Documento.update_counters rimborso.id, 
            :importo   => importo_provvigione
        end    
      end
      return true
    end
    
    
    def decrement_documento      
      unless documento.nil?
        Documento.update_counters documento.id, 
          importo: - prezzo_was
      end
      unless rimborso.nil?
        Documento.update_counters rimborso.id, 
          importo: - prezzo_was
      end  
      return true
    end
    
end
