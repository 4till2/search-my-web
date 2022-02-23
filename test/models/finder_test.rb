require 'test_helper'

class FinderTest < ActiveSupport::TestCase

  setup do
    @account = accounts(:one)
    @query = 'ask'
    @author = 'Yosef Serkez'
    @domain = 'example.com'
    @query_with_scope = "#{@query} author:[#{@author}]"
    @scope = { author: [@author], domain: @domain }
    @query_scope = { author: [@author] }
    @base_scope = { author: nil, domain: nil, source: nil }
  end

  test 'new' do
    assert Finder.new(@query)
    assert Finder.new(@query, account: accounts(:one))
  end

  test 'scope param' do
    f = Finder.new(@query, scope: @scope)
    assert_equal f.inspect_scope, @base_scope.merge(@scope)

    # Use Scope provided
    f = Finder.new(@query_with_scope, scope: @scope)
    assert_equal f.inspect_scope, @base_scope.merge(@query_scope).merge(@scope)

    # Extract Author Scope from query
    f = Finder.new(@query_with_scope)
    assert_equal f.authors, [@author]

    # Extract Domain Scope from query
    f = Finder.new("#{@query} domain:[#{@domain}]")
    assert_equal f.domains, [@domain]

    # Extract Sources Scope from query
    f = Finder.new("#{@query} source:[tech]")
    assert_equal f.sources, ['tech']
  end

  test 'validate scope' do
    f = Finder.new(@query_with_scope, scope: { **@scope, another: 'option' })
    assert_equal f.inspect_scope, @base_scope.merge(@query_scope).merge(@scope)

    f = Finder.new("#{@query_with_scope} another:[option]")
    assert_equal f.inspect_scope, @base_scope.merge(@query_scope)
  end

  test 'query' do
    # removes params from final query
    f = Finder.new(@query_with_scope)
    assert f.query, @query
  end

  test 'search' do
    assert_equal 0, Finder.new('missing').search.count
    assert_equal 3, Finder.new(@query).search.count
    assert_equal 3, Finder.new(@query_with_scope).search.count
  end

  test 'scope domain' do
    assert_empty Finder.new(@query, scope: { domain: 'https://yikes.com' }).search
    assert_not_empty Finder.new(@query, scope: { domain: @domain }).search
    assert_equal 3, Finder.new(@query, scope: { author: 'Yosef Serkez' }).search.count
    assert_equal 1, Finder.new(@query, scope: { author: 'Yosef Serkez', domain: 'example.com' }).search.count
  end

  test 'scope author' do
    assert_empty Finder.new(@query, scope: { author: 'Justin Vernon' }).search
    assert_not_empty Finder.new(@query, scope: { author: @author }).search
  end

  test 'search source scope' do
    label_a, label_b, label_c = 'a', 'b', 'c'
    is_source = Source.create!(account: @account, sourceable: pages(:two))
    assert is_source.label_list.add(label_a, label_b) && is_source.save
    is_source_second = Source.create!(account: @account, sourceable: pages(:three))
    assert is_source_second.label_list.add(label_b, label_c) && is_source_second.save

    # add the same label to another accounts sources to ensure its not retrieved
    not_source = Source.create!(account: accounts(:two), sourceable: pages(:one))
    assert not_source.label_list.add(label_a) && not_source.save

    # Account missing
    assert_equal 0, Finder.new(@query, scope: { source: label_a }).search.count
    # Account missing source
    assert_equal 0, Finder.new(@query, scope: { source: 'yosefs blog' }, account: @account).search.count
    # Account has source
    assert_equal 1, Finder.new(@query, scope: { source: label_a }, account: @account).search.count
    # Account has two matching pages from the same label
    assert_equal 2, Finder.new(@query, scope: { source: label_b }, account: @account).search.count
    # Account has two matching pages from separate labels
    assert_equal 2, Finder.new(@query, scope: { source: [label_a, label_c] }, account: @account).search.count
    # Search matches three labels, but two unique pages
    assert_equal 2, Finder.new(@query, scope: { source: [label_a, label_b, label_c] }, account: @account).search.count

  end
end
