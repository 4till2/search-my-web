class Word < ApplicationRecord
  include PgSearch::Model
  # any_word matching one of the search params will be returned. This means just one proper stem will include
  # a page. The page with the most stems will be shown first, with the potential for many weak suggestions below.
  pg_search_scope :search_stem,
                  against: :stem,
                  using: {
                    tsearch: {
                      dictionary: 'simple', tsvector_column: 'searchable', any_word: true
                    }
                  }
  has_many :locations, dependent: :destroy
  has_many :pages, through: :locations

end
