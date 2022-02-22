require 'test_helper'

class FinderTest < ActiveSupport::TestCase

  setup do
    @query = 'ask'
    @author = 'Yosef Serkez'
    @domain = 'example.com'
    @query_with_scope = "#{@query} author:[#{@author}]"
    @scope = { author: [@author], domain: @domain }
    @query_scope = { author: [@author] }
  end

  test 'new' do
    assert Finder.new(@query)
    assert Finder.new(@query, accounts(:one))
  end

  test 'scope param' do
    f = Finder.new(@query, @scope)
    assert_equal f.scope, @scope

    # Use Scope provided
    f = Finder.new(@query_with_scope, @scope)
    assert_equal f.scope, @scope

    # Extract Scope from query
    f = Finder.new(@query_with_scope)
    assert_equal f.scope, @query_scope
  end

  test 'validate scope' do
    f = Finder.new(@query_with_scope, { **@scope, another: 'option' })
    assert_equal f.scope, @scope

    f = Finder.new("#{@query_with_scope} another:[option]")
    assert_equal f.scope, @query_scope
  end

  test 'query' do
    # removes params from final query
    f = Finder.new(@query_with_scope)
    assert f.query, @query
  end

  test 'search' do
    assert_empty Finder.new('@querygarbage').search
    assert_not_empty Finder.new(@query, @scope).search
    assert_not_empty Finder.new(@query_with_scope).search
  end

  test 'scope domain' do
    assert_empty Finder.new(@query, { domain: 'https://yikes.com' }).search
    assert_not_empty Finder.new(@query, domain: @domain).search
  end

  test 'scope author' do
    assert_empty Finder.new(@query, { author: 'Justin Vernon' }).search
    assert_not_empty Finder.new(@query, { author: @author }).search
  end
end
