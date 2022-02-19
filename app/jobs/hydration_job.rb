class HydrationJob
  include Sidekiq::Job
  queue_as :default

  def perform(page_id, force = false)
    Page.find(page_id).hydrate(force)

    clear_retries if ENV.fetch('RAILS_ENV', 'development') == 'development'
  end

  def clear_retries
    rs = Sidekiq::RetrySet.new
    rs.size
    rs.clear
  end
end
