require "test_helper"

class PageTest < ActiveSupport::TestCase
  setup do
    @url = 'http://www.example.com'
  end

  test 'create page' do
    assert Page.create! url: @url
  end

  test 'valid url only' do
    assert_raises(ActiveRecord::RecordInvalid, 'Url is not a valid URL') { Page.create! url: 'google.com' }
  end

  test 'refresh updates last indexed' do
    p = Page.create! url: @url
    a = p.last_indexed
    assert p.hydrate
    assert_not_equal a, p.last_indexed
  end

  test 'build links' do
    l1 = Link.count
    p = Page.create!(url: 'https://nokogiri.org')
    assert p.hydrate(false)
    assert p.build_links
    assert_not_equal l1, Link.count
  end

  test 'force refresh' do
    p = Page.create!(url: 'https://nokogiri.org')
    assert p.hydrate(false)
    assert_not p.hydrate(false)
    assert p.hydrate(true)
  end

  # pages(:one).searchable: "'ask':25C 'coordin':23C 'document':13C 'domain':2A,5C,18C 'exampl':1A,11C 'example.com':3B 'illustr':10C 'inform':29C 'literatur':20C 'may':15C 'permiss':27C 'prior':22C 'use':8C,16C 'without':21C"
  test 'search' do
    assert_empty Page.search('ass')
    assert_not_empty Page.search('ask')
  end
end
