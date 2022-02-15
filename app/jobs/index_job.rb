class IndexJob
  include Sidekiq::Job
  queue_as :default

  def perform(url, account_id)
    index = Indexer.new.process(url)
    Source.add(index[:page].id, account_id) if account_id && index[:page]
  end
end
