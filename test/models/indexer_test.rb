require "test_helper"

class IndexerTest < ActiveSupport::TestCase
  setup do
    @url = "http://www.example.com"
  end

  def test_string_to_words
    assert_equal %w[squawk hello world], Indexer.new.words_from('the squawk! Hello   World')
  end


  test 'process one url' do
    indexer = Indexer.new
    assert indexer.process(@url)
  end

  test 'fail gracefully for invalid url' do
    indexer = Indexer.new
    assert_not indexer.process('invalidurl.com')
  end

  test 'process one url with hydration' do
    indexer = Indexer.new
    page = indexer.process(@url)
    assert page
    assert page.hydration
    assert page.hydration.content.present?
  end

  test 'process one url with hydration and words' do
    indexer = Indexer.new
    assert_difference 'Word.count', 12 do
      indexer.process(@url)
    end
  end
end
