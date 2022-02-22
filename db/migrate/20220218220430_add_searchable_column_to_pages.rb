class AddSearchableColumnToPages < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE pages
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(url, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(author, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(content,'')), 'C')
      ) STORED;
    SQL
  end

  def down
    remove_column :pages, :searchable
  end
end
