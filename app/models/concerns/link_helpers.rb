module LinkHelpers
  DO_NOT_CRAWL_TYPES = %w[.pdf .doc .xls .ppt .mp3 .m4v .avi .mpg .rss .xml .json .txt .git .zip .md5 .asc .jpg .gif .png].freeze
  extend ActiveSupport::Concern

  # scrub the given link
  def scrub(link, host = nil)
    return if link.nil? || !link.valid_url?

    return nil if DO_NOT_CRAWL_TYPES.include?(link[(link.size - 4)..link.size]) || link.include?('?') ||
      link.include?('/cgi-bin/') || link.include?('&') || (link[0..8] == 'javascript') ||
      (link[0..5] == 'mailto')

    link = link.index('#').zero? ? '' : link[0..link.index('#') - 1] if link.include? '#'
    if link[0..3] == 'http'
      link
    else
      URI.join(host, link)
    end
  end
end
