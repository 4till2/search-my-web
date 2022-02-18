class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :url
      t.datetime :last_indexed
      t.integer :rank, default: 1

      t.timestamps
    end
  end
end
