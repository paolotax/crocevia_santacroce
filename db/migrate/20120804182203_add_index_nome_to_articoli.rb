class AddIndexNomeToArticoli < ActiveRecord::Migration
  def change
    add_index :articoli, :nome
  end
end
