class AddDocumentoIdToArticoli < ActiveRecord::Migration
  def change
    add_column :articoli, :documento_id, :integer
    
    add_index :articoli, :documento_id
  end
end
