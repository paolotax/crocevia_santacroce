class AddScadenzaToCategorie < ActiveRecord::Migration
  
  class Categoria < ActiveRecord::Base
    attr_accessible :nome, :provvigione, :scadenza, :patate

    has_many :articoli, dependent:  :nullify
  end

  class Articolo < ActiveRecord::Base
    belongs_to :categoria
  end

  def up
    add_column :categorie, :scadenza, :integer
    add_column :categorie, :patate,   :integer
    
    Categoria.reset_column_information

    Categoria.create! nome: "50% - 60 giorni", provvigione: 50, scadenza: 60, patate: 90
    Categoria.create! nome: "65% - 60 giorni", provvigione: 65, scadenza: 60, patate: 90
    Categoria.create! nome: "30 giorni 50%", provvigione: 50, scadenza: 30, patate: 60
    
    Categoria.all.each do |c|
      if c.patate == 90
        articoli = Articolo.where(provvigione: c.provvigione)
        c.articoli << articoli
      end
    end  
  end

  
  def down
    remove_column :categorie, :patate
    remove_column :categorie, :scadenza

    Categoria.reset_column_information
    Categoria.destroy_all  
  end

end
