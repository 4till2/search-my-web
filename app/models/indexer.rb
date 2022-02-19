class Indexer
  include LinkHelpers

  def process(url, force: false)
    return { error: true, page: nil, indexed: false, message: 'invalid url' } unless url.valid_url?

    add_to_index url, force
  end

  # add the page to the index
  def add_to_index(url, force = false)
    puts format "\n- indexing #{url}"
    t0 = Time.now
    page = Page.find_or_create_by(url: url)
    indexed = page.hydrate if page.stale? || force
    t1 = Time.now
    puts format('  [%6.2f sec]', (t1 - t0))
    { page: page, indexed: indexed }
  end
end
