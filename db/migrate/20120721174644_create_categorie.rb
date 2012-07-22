class CreateCategorie < ActiveRecord::Migration
  def change
    create_table :categorie do |t|
      t.string :nome
      t.integer :provvigione

      t.timestamps
    end
  end
end
