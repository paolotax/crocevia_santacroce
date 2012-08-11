class Documento < ActiveRecord::Base
  attr_accessible :importo, :tipo
  
  has_many :movimenti, dependent: :nullify
  
  def add_movimenti_attivi(user)
    for m in user.movimenti.attivo do
      self.movimenti << m
    end
  end
end
