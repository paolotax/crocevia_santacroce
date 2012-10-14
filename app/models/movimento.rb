class Movimento < ActiveRecord::Base
  attr_accessible :data, :prezzo, :quantita, :tipo, :articolo_id
  
  belongs_to :articolo, counter_cache: true
  belongs_to :user
  belongs_to :documento
  
  has_one :cliente, through: :articolo
  
  validate :validate_articolo, on: :create
  
  def validate_articolo
    if Articolo.find_by_id(articolo_id)
      errors.add(:articolo, "Articolo esaurito!") if self.articolo.disponibile? == false
    else
      errors.add(:articolo, "Codice non trovato!")
    end
  end
  
  before_save :set_prezzo
  
  scope :attivo, where(documento_id: nil)
  
  # include ActionView::Helpers::DateHelper
  # after_save :update_documento_importo
  # 
  # def update_documento_importo
  #   return true unless quantita_changed?
  #   Documento.update_counters documento.id, 
  #     :importo => (quantita - (quantita_was || 0))
  #   return true
  # end
  
  def da_registrare?
    documento.nil?
  end
  
  def da_rimborsare?
    vendita? && !documento.nil? && documento.data < Time.now.beginning_of_month.to_date
  end
  
  %w(vendita resa).each do |tipo|
    scope "#{tipo}", where('movimenti.tipo = ?', "#{tipo}")
    
    define_method "#{tipo}?" do
      self.tipo == tipo
    end
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
end
