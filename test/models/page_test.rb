require "test_helper"

class PageTest < ActiveSupport::TestCase
  setup do
    @url = 'http://www.example.com'
  end

  test 'create page' do
    assert Page.create! url: @url
  end

  test 'page is automatically hydrated ' do
    p = Page.create! url: @url
    assert p.hydration.present?
  end

  test 'valid url only' do
    assert_raises(ActiveRecord::RecordInvalid, 'Url is not a valid URL') { Page.create! url: 'google.com' }
  end

end
