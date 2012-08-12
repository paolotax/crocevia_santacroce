class CreateDocumenti < ActiveRecord::Migration
  def change
    create_table :documenti do |t|
      t.string :tipo
      t.date :data
      t.decimal :importo, :precision => 7, :scale => 2, :default => 0.0

      t.timestamps
    end
    
    add_column :movimenti, :documento_id, :integer
    add_column :movimenti, :user_id, :integer
    
    add_index :movimenti, :documento_id
    add_index :movimenti, :user_id
    
    remove_column :movimenti, :data
    
  end
end
