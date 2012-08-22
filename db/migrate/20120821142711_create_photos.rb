class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :photo
      t.integer :message_id

      t.timestamps
    end
    
    add_index :photos, :message_id
  end
end
