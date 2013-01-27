class AddEliToArticoli < ActiveRecord::Migration
  def change
    add_column :articoli, :eli, :boolean
  end
end
