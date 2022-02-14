class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.references :account, null: false, foreign_key: true
      t.references :page, null: false, foreign_key: true
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
