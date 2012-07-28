class AddFieldsToClienti < ActiveRecord::Migration
  def change
    add_column :clienti, :documento_rilasciato_da, :string
    add_column :clienti, :telefono, :string
    add_column :clienti, :cellulare, :string
    add_column :clienti, :email, :string
    add_column :clienti, :note, :text
    add_column :clienti, :slug, :string
    
    rename_column :clienti, :scadenza_documento, :data_rilascio_documento
    
    add_index :clienti, :slug
  end
end
