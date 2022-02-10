require 'test_helper'

class FinderTest < ActiveSupport::TestCase

  setup do
    @finder = Finder.new
    @p1 = Page.create!(url: 'https://example.com')
    @p2 = Page.create!(url: 'https://example2.com')
    @string = 'word'
    @stem = @string.as_word_stems.first
    @word = Word.create!(stem: @stem)
  end

  test 'words' do
    assert_not @finder.words('random').present?

    assert @word
    assert @finder.words(@string).present?
  end

  test 'locations' do
    assert_not @finder.locations(@finder.words(@string)).present?

    Location.create!(word: @word, page: @p1)
    assert @finder.locations(@finder.words(@string)).present?
  end

  test 'ranks' do
    assert_not @finder.ranks(@finder.locations(@finder.words(@string))).present?

    Location.create!(word: @word, page: @p1)
    2.times { Location.create!(word: @word, page: @p2) }

    ranks = @finder.ranks(@finder.locations(@finder.words(@string)))
    assert ranks.present?
    # p2 should be first in the ranks
    assert_equal ranks.first[0], @p2.id
  end

  test 'sorted pages' do
    assert_not @finder.pages(@finder.ranks(@finder.locations(@finder.words(@string)))).present?
    Location.create!(word: @word, page: @p1)
    2.times { Location.create!(word: @word, page: @p2) }
    ranks = @finder.ranks(@finder.locations(@finder.words(@string)), true)
    pages = @finder.pages(ranks)
    assert pages.present?
    # not yet sorted by rank
    assert_not_equal pages.first.id, ranks.first
    pages = @finder.sort_pages_by_ranks(pages, ranks)
    # sorted by rank
    assert_equal pages.first.id, ranks.first
  end

  test 'search one word' do
    assert_not @finder.search(@string).present?
    Location.create!(word: @word, page: @p1)
    assert @finder.search(@string).present?
  end

  test 'search multiple words' do
    string = 'apples and bananas'
    assert_not @finder.search(string).present?
    string.as_word_stems.each do |s|
      w = Word.create! stem: s
      Location.create!(word: w, page: @p1)
      assert @finder.words(s).present?
    end
    assert @finder.search(string).present?
  end

end
