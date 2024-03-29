require 'test_helper'

class IndexerTest < ActiveSupport::TestCase
  setup do
    @url = 'http://www.example.com'
  end

  test 'process one url' do
    indexer = Indexer.new
    assert indexer.process(@url)
  end

  test 'fail gracefully for invalid url' do
    indexer = Indexer.new
    assert_equal indexer.process('invalidurl.com')[:error], true
  end

  test 'process one url with hydration' do
    indexer = Indexer.new
    page = indexer.process(@url)[:page]
    assert page
    assert page.content.present?
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
    assert indexer.process(@url, force: true)
  end
end
