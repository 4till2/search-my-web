class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.references :account, null: false, foreign_key: true
      t.references :sourceable, null: false, polymorphic: true
      t.integer :rank, default: 1
      t.string :name
      t.timestamps
    end
  end
end
