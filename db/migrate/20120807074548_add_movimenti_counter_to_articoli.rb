class AddMovimentiCounterToArticoli < ActiveRecord::Migration
  def change
    add_column :articoli, :movimenti_count, :integer, :default => 0
  end
  
  
end
