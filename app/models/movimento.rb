class Movimento < ActiveRecord::Base
  attr_accessible :data, :prezzo, :quantita, :tipo
  
  belongs_to :articolo
end
