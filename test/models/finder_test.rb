require 'test_helper'

class FinderTest < ActiveSupport::TestCase

  setup do
    @finder = Finder
    # @p1 = Page.create!(url: 'https://example.com')
    # @p2 = Page.create!(url: 'https://example2.com')
    # @string = 'word'
  end

  # test 'filter scoped to account' do
  #   assert Source.create(account: accounts(:one), sourceable: pages(:two))
  #   assert_not @finder.filter([locations(:two)], accounts(:one)).present?
  #   assert @finder.filter([locations(:one)], accounts(:one)).present?
  #   assert_equal @finder.filter([locations(:two), locations(:one)], accounts(:one)).count, 1
  # end

end
