class Documento < ActiveRecord::Base
  
  attr_accessible :data, :importo, :tipo
  
  has_many :articoli
  has_many :movimenti, dependent: :destroy
  has_many :cliente, through: :movimenti, uniq: true
  
  scope :recente, order("documenti.id desc")
  
  TIPO_DOCUMENTO = %w(cassa reso carico)
  
  TIPO_DOCUMENTO.each do |tipo|
    scope "#{tipo.split.join.underscore}", where("documenti.tipo = ?", tipo)  
    define_method "#{tipo.split.join.underscore}?" do
      self.tipo == tipo
    end
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
