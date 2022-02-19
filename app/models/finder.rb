class Finder
  def self.search(query, account = nil, scope = false)
    return unless query

    pages = Page.search_page(query)
    scope && account ? filter(pages, account) : pages
  end

  def filter(pages, account)
    pages
    # return pages unless account
    #
    # sources = account.sources.pages.trusted.map(&:sourceable)
    # pages.filter { |p| sources.include?(p) }
  end

end
