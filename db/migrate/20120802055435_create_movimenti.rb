class CreateMovimenti < ActiveRecord::Migration
  def change
    create_table :movimenti do |t|
      t.string :tipo
      t.integer :quantita, default: 1
      t.decimal :prezzo, :precision => 7, :scale => 2
      t.string :data
      t.integer :articolo_id 
      t.timestamps
    end
    
    add_index :movimenti, :articolo_id
    
  end
end
