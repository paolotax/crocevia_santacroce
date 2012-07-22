class Articolo < ActiveRecord::Base
  
  belongs_to :cliente
  
  attr_accessible :categoria_id, :cliente_id, :nome, :prezzo, :provvigione, :quantita
end
