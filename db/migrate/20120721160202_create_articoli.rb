class CreateArticoli < ActiveRecord::Migration
  def change
    create_table :articoli do |t|
      t.string :nome
      t.integer :quantita
      t.decimal :prezzo, :precision => 7, :scale => 2
      t.decimal :prezzo_vendita, :precision => 7, :scale => 2
      t.integer :provvigione
      t.integer :cliente_id
      t.integer :categoria_id
      
      t.timestamps
    end
    add_index :articoli, :cliente_id
    add_index :articoli, :categoria_id
  end
end
