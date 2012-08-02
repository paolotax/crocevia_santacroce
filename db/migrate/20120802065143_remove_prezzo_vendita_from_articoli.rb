class RemovePrezzoVenditaFromArticoli < ActiveRecord::Migration
  def up
    remove_column :articoli, :prezzo_vendita
  end

  def down
    add_column :articoli, :prezzo_vendita, :integer
  end
end
