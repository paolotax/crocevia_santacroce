class Articolo < ActiveRecord::Base
  
  belongs_to :cliente
  
  attr_accessible :categoria_id, :cliente_id, :nome, :prezzo_in_euro, :provvigione, :quantita

  def importo
    self.quantita.to_f * self.prezzo.to_f
  end
    
  def prezzo_in_euro
    prezzo.to_d/100 if prezzo
  end
  
  def prezzo_in_euro=(euros)
    self.prezzo = euros.to_d if euros.present?
  end
end
