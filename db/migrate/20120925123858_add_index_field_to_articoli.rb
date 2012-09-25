class AddIndexFieldToArticoli < ActiveRecord::Migration
  def change
    add_column :articoli, :index, :string
    add_index  :articoli, :index
    
    add_column :clienti, :index, :string
    add_index  :clienti, :index
  end
end
