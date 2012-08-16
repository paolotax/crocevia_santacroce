class Documento < ActiveRecord::Base
  
  attr_accessible :data, :importo, :tipo
  
  has_many :movimenti, dependent: :destroy
  has_many :cliente, through: :movimenti, uniq: true
  
  scope :recente, order("documenti.id desc")
  
  TIPO_DOCUMENTO = %w(cassa reso)
  
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
end
