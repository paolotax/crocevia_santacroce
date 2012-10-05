class Documento < ActiveRecord::Base
  
  attr_accessible :data, :importo, :tipo
  
  has_many :articoli
  has_many :movimenti, dependent: :destroy
  
  has_many :clienti, through: :articoli
  
  scope :recente, order("documenti.id desc")
  
  TIPO_DOCUMENTO = %w(cassa reso carico)
  
  TIPO_DOCUMENTO.each do |tipo|
    scope "#{tipo.split.join.underscore}", where("documenti.tipo = ?", tipo)  
    
    define_method "#{tipo.split.join.underscore}?" do
      self.tipo == tipo
    end
  end
  
  def mandante
    if %w(reso carico).include? tipo
      clienti.uniq.first
    end  
  end
  
  def numero_articoli
    articoli.sum(&:quantita)
  end
  
  def importo_carico
    articoli.sum { |a| a.prezzo * a.quantita }
  end
  
  def realizzo
    articoli.sum { |a| a.prezzo * a.quantita * a.provvigione / 100 }
  end
  
  
        
  def add_movimenti_attivi(user)
    self.importo = user.movimenti.attivo.sum(&:prezzo)
    for m in user.movimenti.attivo do
      self.movimenti << m
    end  
  end
  
  def add_articoli_cliente(cliente_id)
    cliente = Cliente.find(cliente_id)
    self.importo = cliente.articoli.attivo.sum(&:prezzo)
    for a in cliente.articoli.attivo do
      self.articoli << a
    end  
  end
  
end
