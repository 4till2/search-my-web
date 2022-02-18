class Importer
  FAILED = 'failed'.freeze
  READY = 'ready'.freeze
  COMPLETE = 'complete'.freeze
  attr_accessor :urls, :errors, :pages

  # @param data : todo: Can be nearly any data type and importer will try to find some urls. Base case is a String. Arrays of multiple data types are supported.
  # @example data = ['https://example.com', ['https://example.com','https://example.com'], HTML_FILE]
  # (File is not yet supported on the backend, but the front end handles conversion of HTML files)
  def initialize(data, account = nil)
    @account = account
    @urls = []
    @pages = []
    @errors = []
    process_data(data) unless data.nil?
  end

  def self.process(data, account = nil)
    Importer.new(data, account).run
  end

  def run
    index_urls
  end

  def process_data(data)
    case data
    when String
      process_string(data)
    when Array # recursively handles an array of urls, or an array of different data sources
      data.each { |d| process_data(d) }
    when File
      @errors << { error: 'File Import not yet supported', node: data }
    else
      @errors << { error: 'Data type not yet supported', node: data }
    end
  end

  def process_string(str)
    if str.valid_url?
      @urls << { url: str, status: READY }
    else
      @errors << { error: 'Invalid URL', node: str }
    end
  end

  def ready
    @urls.select { |u| u[:status] == READY }
  end

  def complete
    @urls.select { |u| u[:status] == COMPLETE }
  end

  def failed
    @urls.select { |u| u[:status] == FAILED }
  end

  private

  def index_urls
    ready.each do |item|
      IndexJob.perform_async(item[:url], @account&.id)
      item[:status] = COMPLETE
    end
  end
end
