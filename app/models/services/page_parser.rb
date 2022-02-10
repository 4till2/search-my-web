module Services
  class PageParser
    attr_reader :url

    def initialize(url, data = nil, user = ENV["EXTRACT_USER"])
      @url = url
      @user = user
      load_data(data) if data
    end

    def self.parse(*args)
      # Librato.increment "readability.first_parse"
      new(*args)
    end

    def title
      result["title"]
    end

    def content
      result["content"]
    end

    def author
      result["author"]
    end

    def published
      if result["date_published"]
        Time.parse(result["date_published"])
      end
    rescue
      nil
    end

    def date_published
      result["date_published"]
    end

    def domain
      result["domain"]
    end

    def lead_image_url
      result["lead_image_url"]
    end

    def excerpt
      result["excerpt"]
    end

    def summary
      result["excerpt"]
    end

    def categories
      result["categories"]
    end

    def direction
      result["direction"]
    end

    def word_count
      result["word_count"]
    end

    def to_h
      {
        result: result,
        url: url
      }
    end

    def service_url
      @service_url ||= begin
                         digest = OpenSSL::Digest.new("sha1")
                         signature = OpenSSL::HMAC.hexdigest(digest, ENV["EXTRACT_SECRET"], url)
                         base64_url = Base64.urlsafe_encode64(url).delete("\n")
                         # TODO: FOR PRODUCTION CHANGE TO HTTPS.build
                         URI::HTTP.build({
                                           host: ENV["EXTRACT_HOST"],
                                           port: ENV["EXTRACT_PORT"],
                                           path: "/parser/#{@user}/#{signature}",
                                           query: "base64_url=#{base64_url}"
                                         }).to_s
                       end
    end

    private

    def result
      @result ||= HTTParty.get(service_url)
    end

    def marshal_dump
      to_h
    end

    def marshal_load(data)
      @result = data[:result]
      @url = data[:url]
    end

    def load_data(data)
      @result = data["result"]
      @url = data["url"]
    end
  end

end
