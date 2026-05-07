class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.integer :pexels_id, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.string :source_url, null: false
      t.string :photographer, null: false
      t.string :medium_url, null: false
      t.text :alt
      t.integer :likes_count, null: false, default: 0

      t.timestamps
    end

    add_index :photos, :pexels_id, unique: true
  end
end
