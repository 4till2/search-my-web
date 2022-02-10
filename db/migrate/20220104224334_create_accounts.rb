class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nickname, null: false

      t.timestamps
    end
    add_index :accounts, :nickname, unique: true
  end
end
