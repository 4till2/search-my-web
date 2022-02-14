class Finder
  SEARCH_LIMIT = 19

  # Temporarily naive algorithm that gets the job done.
  #
  # convert query to word stems -> get all locations matching word stems ->
  # get list of sorted page ids according their frequency in list of locations -> get pages -> order pages
  def search(query, account = nil)
    return unless query

    words = words(query)
    locations = locations(words)
    return unless locations

    filtered_locations = filter(locations, account)

    ranked_ids = ranks(filtered_locations, true)
    pages = pages(ranked_ids)
    sort_pages_by_ranks(pages, ranked_ids)
  end

  def words(query)
    stems = query.as_word_stems.join(' ')
    Word.search_stem(stems)
  end

  def locations(words)
    words&.map(&:locations)&.first
  end

  def filter(locations, account)
    return locations unless account

    sources = account.sources.trusted.map(&:page)
    locations.filter { |l| sources.include?(l.page) }
  end

  def ranks(locations, ids_only = false)
    r = frequency_ranking(locations)
    ids_only ? r&.map { |f| f[0] } : r
  end

  def pages(ids)
    Page.where(id: ids&.first(SEARCH_LIMIT))
  end

  ## Take a array of pages, and sort it to match the corresponding pages id within ranks
  def sort_pages_by_ranks(pages, ranks)
    pages.sort_by do |page|
      [ranks.index(page.id) || -1, page.id]
    end
  end

  # @return an array of the frequency of each page_id in the list of locations. Sorted ascending
  # [Location, Location, Location, ...] -> {1=>4, 2=>8, 3=>4} -> [[2, 8], [1, 4], [3, 4]]
  def frequency_ranking(locations)
    return unless locations.present?

    locations.each_with_object(Hash.new(0)) { |e, h| h[e.page_id] += 1; }.to_a.sort { |a, b| b[1] <=> a[1] }
  end

end
