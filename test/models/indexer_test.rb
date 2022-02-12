require "test_helper"

class IndexerTest < ActiveSupport::TestCase
  setup do
    @url = "http://www.example.com"
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
    page = indexer.process(@url)[:page]
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

  test 'dont process if already indexed' do
    indexer = Indexer.new
    assert indexer.process(@url)
    i = indexer.process(@url)
    assert i
    assert_not i[:indexed]
  end

  test 'force processing' do
    indexer = Indexer.new
    assert indexer.process(@url)
    assert indexer.process(@url, true)
  end
end
