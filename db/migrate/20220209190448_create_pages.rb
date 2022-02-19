class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :url
      t.datetime :last_indexed
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
