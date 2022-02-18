class CreateHydrations < ActiveRecord::Migration[7.0]
  def change
    create_table :hydrations do |t|
      t.references :page, null: false, foreign_key: true
      t.string :title
      t.text :summary
      t.string :author
      t.datetime :date_published
      t.string :lead_image_url
      t.text :content
      t.string :domain
      t.text :excerpt
      t.integer :word_count
      t.string :direction
      t.timestamps
    end
  end
end
