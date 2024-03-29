class IndexJob
  include Sidekiq::Job
  queue_as :default

  def perform(url, account_id)
    index = Indexer.new.process(url)
    Source.create(account_id: account_id, sourceable: index[:page]) if account_id && index[:page]

    clear_retries if ENV.fetch('RAILS_ENV', 'development') == 'development'
  end

  def clear_retries
    rs = Sidekiq::RetrySet.new
    rs.size
    rs.clear
  end
end
