class AddSearchableColumnToWords < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE words
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        to_tsvector('simple', coalesce(stem, ''))
      ) STORED;
    SQL
  end

  def down
    remove_column :words, :searchable
  end
end
