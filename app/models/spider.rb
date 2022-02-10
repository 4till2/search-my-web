LAST_CRAWLED_PAGES = 'seed.yml'
USER_AGENT = 'myweb'

class Spider
  include LinkHelpers

  # start the spider
  def start(pages = nil)
    crawl(pages || YAML.load_file(LAST_CRAWLED_PAGES))
  end

  def crawl(pages)
    until pages.nil? || pages.empty?
      newfound_pages = []
      pages.each do |page_url|
        next unless page_url.valid_url?

        begin
          page = Indexer.new.process(page_url)
          if page.present?
            uri = URI.parse(page_url)
            host = "#{uri.scheme}://#{uri.host}"
            doc = page.hydration.content
            doc.find('a').each do |link|
              url = scrub(link['href'], host)
              newfound_pages << url unless url.nil? || newfound_pages.include?(url) # || !robot.allowed?(url)
            end
          end
        rescue => e
          print "\n** Error encountered crawling - #{page} - #{e.to_s}"
        rescue Timeout::Error => e
          print "\n** Timeout encountered - #{page} - #{e.to_s}"
        end
        pages = newfound_pages
        File.open(LAST_CRAWLED_PAGES, 'w') { |out| YAML.dump(newfound_pages, out) }
      end
    end
  end

end