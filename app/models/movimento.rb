class Movimento < ActiveRecord::Base
  
  attr_accessible :data, :prezzo, :quantita, :tipo, :articolo_id, :rimborso_id
  
  belongs_to :articolo, counter_cache: true
  belongs_to :user
  belongs_to :documento
  belongs_to :rimborso, class_name: 'Documento'
  
  has_one :cliente, through: :articolo
  
  validate :validate_articolo, on: :create
    
  def validate_articolo
    if Articolo.find_by_id(articolo_id)
      errors.add(:articolo, "Articolo esaurito!") if self.articolo.disponibile? == false
    else
      errors.add(:articolo, "Codice non trovato!")
    end
  end
  
  before_save   :set_prezzo
  after_save    :update_documento
  after_destroy :decrement_documento

  %w(vendita resa).each do |tipo|
    scope "#{tipo}", where('movimenti.tipo = ?', "#{tipo}")
    
    define_method "#{tipo}?" do
      self.tipo == tipo
    end
  end
    
  scope :attivo, where(documento_id: nil)
  scope :da_rimborsare, vendita.where("movimenti.rimborso_id is null")
  scope :rimborsabile,  da_rimborsare.joins(:documento).where("documenti.data < ?", Time.now.beginning_of_month.to_date )
  scope :rimborsato, vendita.where("movimenti.rimborso_id is not null")  

  def da_registrare?
    documento.nil?
  end
  
  def rimborsato?
    vendita? && !rimborso_id.nil?
  end
  
  def da_rimborsare?
    vendita? && rimborso_id.nil? && !documento.nil? && documento.data < Time.now.beginning_of_month.to_date
  end
   
  def mandante
    cliente
  end
  
  def set_prezzo
    if prezzo.blank?
      self.prezzo = articolo.prezzo_vendita
      self.quantita = 1
    end 
  end
  
  def importo
    quantita * prezzo
  end
  
  def importo_cliente
    quantita * prezzo
  end
  
  def importo_provvigione
    if articolo.patate?
      0.0
    else
      prezzo / 100 * articolo.provvigione
    end
  end

  def importo_patate
    if articolo.patate?
      prezzo
    else
      0.0
    end
  end
  
  def giorni_di_giacenza
    (Date.parse(created_at.to_s) - Date.parse(articolo.created_at.to_s)).to_i
    # distance_of_time_in_words(self.created_at, self.articolo.created_at) 
  end
  
  def ricavo
    prezzo - importo_patate - importo_provvigione
  end
    
  def patate?
    created_at > articolo.created_at + 3.months
  end
  
  def scaduto?
    created_at > articolo.created_at + 2.months
  end
  
  
  private
    
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
          :importo   => - prezzo_was
      end  
      return true
    end
    
end
