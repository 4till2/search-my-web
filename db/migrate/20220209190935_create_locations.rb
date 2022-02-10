class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.integer :position
      t.references :page, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end

    add_index :locations, [:page_id, :word_id]
  end

end
