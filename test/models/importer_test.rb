require 'test_helper'

class ImporterTest < ActiveSupport::TestCase
  setup do
    @url = 'http://www.example.com'
  end

  test 'create importer with data' do
    i = Importer.new(@url)
    assert_equal i.urls, [{ url: @url, status: 'ready' }]
    i = Importer.new([@url, @url])
    assert_equal i.urls, [{ url: @url, status: 'ready' }, { url: @url, status: 'ready' }]
  end

  test 'create importer with bad data' do
    i = Importer.new([@url, 'invalidurl'])
    assert_equal i.urls.count, 1
    assert_equal i.errors.first[:node], 'invalidurl'
  end

  test 'run index on urls' do
    i = Importer.new([@url, 'invalidurl'])
    assert_difference 'i.urls.filter { |e| e[:status] == "complete" }.count' do
      i.run
    end
  end

  test 'run async' do
    assert Importer.process([@url, 'invalidurl'])
    assert Importer.process([@url, 'invalidurl'], accounts(:one))
  end

end