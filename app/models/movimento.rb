class Movimento < ActiveRecord::Base
  attr_accessible :data, :prezzo, :quantita, :tipo, :articolo_id
  
  belongs_to :articolo, counter_cache: true
  
  before_save :set_prezzo
  
  # include ActionView::Helpers::DateHelper
  
  def set_prezzo
    if self.prezzo.blank?
      self.prezzo = self.articolo.prezzo_vendita
      self.quantita = 1
    end 
  end
  
  def importo_provvigione
    if self.articolo.patate?
      0.0
    else
      self.prezzo / 100 * self.articolo.provvigione
    end
  end

  def importo_patate
    if self.articolo.patate?
      self.prezzo
    else
      0.0
    end
  end
  
  def giorni_di_giacenza
    (Date.parse(self.created_at.to_s) - Date.parse(self.articolo.created_at.to_s)).to_i
    # distance_of_time_in_words(self.created_at, self.articolo.created_at) 
  end
  
  def ricavo
    self.prezzo - self.importo_patate - self.importo_provvigione
  end
    
  def patate?
    self.created_at > self.articolo.created_at + 3.months
  end
  
  def scaduto?
    self.created_at > self.articolo.created_at + 2.months
  end
end
