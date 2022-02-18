class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.references :origin, null: false, foreign_key: { to_table: :pages }
      t.references :destination, null: false, foreign_key: { to_table: :pages }

      t.timestamps
    end
  end
end
