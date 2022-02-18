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

  test 'refresh updates created_at' do
    p = Page.create! url: @url
    a = p.updated_at
    assert p.refresh
    assert_not_equal a, p.updated_at
  end

end
