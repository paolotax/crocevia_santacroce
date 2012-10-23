class AddRimborsoIdToMovimenti < ActiveRecord::Migration
  def change
    add_column :movimenti, :rimborso_id, :integer
    add_index :movimenti, :rimborso_id
  end
end
