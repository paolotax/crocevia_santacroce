class Documento < ActiveRecord::Base
  attr_accessible :data, :importo, :tipo
  
  has_many :movimenti, dependent: :nullify
  
  scope :incasso, where(tipo: "cassa")
  scope :recente, order("documenti.id desc")
  
  
  def add_movimenti_attivi(user)
    self.importo = user.movimenti.attivo.sum(&:prezzo)
    for m in user.movimenti.attivo do
      self.movimenti << m
    end  
  end
end
