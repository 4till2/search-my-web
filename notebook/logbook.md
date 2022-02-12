# Using Turbo Stream
The achitecture for the search bar is to update the stream of results below the search bar
using Hotwire Turbo Streams. When an input is submitted the search controller replaces the content
of the results container with the updated results. 
# Be sure to pin javascript files
With rails 7 importmaps is the way to make javascript files accessible.
In my [search_bar_controller](../app/javascript/controllers/search_bar_controller.js) I import the `debounce` function to
automatically submit the search after a period of pause from [utils.js](../app/javascript/utils.js). To make it available we must import
it in [importmap.rb](../config/importmap.rb) by adding the following line.
```ruby
pin 'utils', preload: true
```
allowing us to then import from utils as expected...
```ruby
import {debounce} from "utils";
```
# Adding Postgresql Full Text Search
I wasn't sure if I should use Postgresql full search or 
another option. But it seemed the quickest way to get going and quite
powerful. In addition the pg_search gem makes it trivial to configure.
1. Add `gem pg_search` to the gemfile
2. Include PgSearch and add a search scope...
```ruby
# app/models/word.rb
class Word < ApplicationRecord
  # +++++
  include PgSearch::Model
  pg_search_scope :search_stem, against: :stem
  # +++++
  # has_many :locations, dependent: :destroy
  # has_many :pages, through: :locations

end
  ```
3. Now a command like `Word.search_stem(STRING.as_word_stems.join(' ')).map { |w| w.locations.map { |l| l.page } }`
   will return all pages matching a given query.

To improve performance we can save and index the search vectors 
5. In [application.rb](../config/application.rb) add `config.active_record.schema_format = :sql`
6. Add searchable column
```ruby
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
```
6. Add Index
```ruby
class AddIndexToSearchableWords < ActiveRecord::Migration[7.0]
  disable_ddl_transaction! # Will throw error without.

  def change
    add_index :words, :searchable, using: :gin, algorithm: :concurrently
  end
end

```
7. Update search scope to use index
```ruby
 pg_search_scope :search_stem,
                  against: :stem,
                  using: {
                    tsearch: {
                      dictionary: 'simple', tsvector_column: 'searchable'
                    }
                  }
```
**Resources**
[Guide](https://pganalyze.com/blog/full-text-search-ruby-rails-postgres)
# Extending core Ruby
**String**
1. add to lib/core_ext/string.rb
2. initialize in config/initializers/core_ext.rb
3. write test in test/core_ext_test.rb

**Resources**
[Lib](https://stackoverflow.com/a/5654580/16975830),
[Test](https://guides.rubyonrails.org/plugins.html#extending-core-classes)
