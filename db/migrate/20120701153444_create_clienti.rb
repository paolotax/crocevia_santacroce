class CreateClienti < ActiveRecord::Migration
  def change
    create_table :clienti do |t|
      t.string :nome
      t.string :cognome
      t.string :ragione_sociale
      t.string :indirizzo
      t.string :cap
      t.string :citta
      t.string :provincia
      t.string :partita_iva
      t.string :codice_fiscale
      t.string :tipo_documento
      t.string :numero_documento
      t.date   :scadenza_documento
      t.integer :numero_tessera

      t.timestamps
    end
  end
end
