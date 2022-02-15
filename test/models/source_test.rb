require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @page = pages(:two) #page one is already a source

  end

  test 'create source' do
    assert Source.create!(account: @account, page: @page)
  end

  test 'dont create duplicate source' do
    assert_raises(ActiveRecord::RecordInvalid, 'Duplicate source') {
      Source.create!(account: @account, page: pages(:one))
    }
  end
end
