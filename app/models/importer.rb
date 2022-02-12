class Importer
  FAILED = 'failed'.freeze
  READY = 'ready'.freeze
  COMPLETE = 'complete'.freeze
  attr_accessor :urls, :errors

  # @param data : Can be nearly any data type and importer will try to find some urls. Base case is a String. Arrays of multiple data types are supported.
  # @example data = ['https://example.com', ['https://example.com','https://example.com'], HTML_FILE]
  # (File is not yet supported on the backend, but the front end handles conversion of HTML files)
  def initialize(data = nil)
    @urls = []
    @errors = []
    process_data(data) unless data.nil?
  end

  def run
    result = index_urls
    puts result
    result
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
    total = 0
    indexer = Indexer.new
    time = benchmark do
      ready.each do |l|
        l[:status] = indexer.process(l[:url]) ? COMPLETE : FAILED
      end
    end
    { attempts: total, run_time: time }
  end

  def benchmark
    t0 = Time.now
    yield
    t1 = Time.now
    format('%6.2f', (t1 - t0))
  end
end
