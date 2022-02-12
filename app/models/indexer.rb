class Indexer
  include LinkHelpers

  def process(page_url, force = false)
    return unless page_url.valid_url?

    add_to_index page_url, force
  end

  # add the page to the index
  def add_to_index(url, force = false)
    print "\n- indexing #{url}"
    t0 = Time.now
    page = Page.find_or_create(scrub(url))

    # if the page is not in the index, then index it
    if page.new_record?
      h = Hydration.new(page: page)
      h.pour(page.url)
      doc = h&.content
      index(doc) do |doc_words|
        dsize = doc_words.size.to_f
        puts " [new] - (#{dsize.to_i} words)"
        doc_words.each_with_index do |w, l|
          puts format("\r\e - %6.2f", (l * 100 / dsize))
          loc = Location.new(position: l)
          loc.word = Word.find_or_create_by(stem: w)
          loc.page = page
          loc.save
        end
      end

      # if it is but it is not fresh, then update it
    elsif !page.fresh? || force
      page.refresh
      doc = page.hydration&.content
      index(doc) do |doc_words|
        dsize = doc_words.size.to_f
        puts " [refreshed] - (#{dsize.to_i} words)"
        page.locations.destroy
        doc_words.each_with_index do |w, l|
          puts format("\r\e - %6.2f", (l * 100 / dsize))
          loc = Location.new(position: l)
          loc.word = Word.find_or_create_by(stem: w)
          loc.page = page
          loc.save
        end
      end
    else
      puts "(x) already indexed - #{url}"
      return { page: page, indexed: false, message: 'already indexed' }
    end
    t1 = Time.now
    puts format('  [%6.2f sec]', (t1 - t0))
    page.save
    { page: page, indexed: false }
  end

  # do the common indexing work
  def index(doc)
    raise 'Missing Doc' && return if doc.nil?

    text = Formatters::Html.clean_text(doc)
    yield(text.as_word_stems)
  end

end