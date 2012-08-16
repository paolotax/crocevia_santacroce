class AddDataDiNascitaToClienti < ActiveRecord::Migration
  def change
    add_column :clienti, :data_di_nascita, :date
    add_column :clienti, :comune_di_nascita, :string
    add_column :clienti, :sesso, :string, size: 1
  end
end
