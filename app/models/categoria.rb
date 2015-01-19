class Categoria < ActiveRecord::Base
  attr_accessible :nome, :provvigione, :scadenza, :patate

  has_many :articoli
end
