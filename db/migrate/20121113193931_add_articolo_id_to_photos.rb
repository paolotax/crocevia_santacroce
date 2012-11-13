class AddArticoloIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :articolo_id, :integer
    add_index  :photos, :articolo_id
  end
end
