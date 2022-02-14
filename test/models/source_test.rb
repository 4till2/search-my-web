require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @page = pages(:one)

  end

  test 'create source' do
    assert Source.create!(account: @account, page: @page)
  end
end
